% ==========================================================
% RULES.PL - Semantic Bridging Logic for Recommendations
% ==========================================================

% ----------------------------------------------------------
% 1. SEMANTIC ABSTRACTIONS
% ----------------------------------------------------------

product_name(P, Name) :-
    functional_complex(P, Name, _, _, _).

product_brand(P, BrandID) :-
    functional_complex(P, _, _, BrandID, _).

product_category(P, CatID) :-
    functional_complex(P, _, _, _, CatID).

same_brand(P1, P2) :-
    product_brand(P1, BrandID),
    product_brand(P2, BrandID),
    P1 \= P2.

same_category(P1, P2) :-
    product_category(P1, CatID),
    product_category(P2, CatID),
    P1 \= P2.

related_also_buy(P1, P2) :-
    also_buy(P1, P2) ;
    also_buy(P2, P1).

related_also_view(P1, P2) :-
    also_view(P1, P2) ;
    also_view(P2, P1).

% ----------------------------------------------------------
% 2. ONTOLOGICAL UNPACKING
% ----------------------------------------------------------

unpack_relation(P1, P2, 'Ecosystem Synergy') :-
    related_also_buy(P1, P2),
    same_brand(P1, P2).

unpack_relation(P1, P2, 'Solution Composition') :-
    related_also_buy(P1, P2),
    product_category(P1, Cat1),
    product_category(P2, Cat2),
    Cat1 \= Cat2.

unpack_relation(P1, P2, 'Quality Competition') :-
    related_also_view(P1, P2),
    same_category(P1, P2).

user_intent_alignment(UserID, ProdID) :-
    mentions(UserID, CatID),
    product_category(ProdID, CatID).

% ----------------------------------------------------------
% 3. SEMANTIC RECOMMENDATIONS
% ----------------------------------------------------------

semantic_recommendation(UserID, TargetProd, Reason) :-
    buys(UserID, BoughtProd),
    unpack_relation(BoughtProd, TargetProd, UnpackedType),
    \+ buys(UserID, TargetProd),
    user_intent_alignment(UserID, TargetProd),
    atomic_list_concat(
        ['This item offers ', UnpackedType,
         ' and aligns with your interest in this category.'],
        Reason
    ).

semantic_recommendation(UserID, TargetProd, 'Brand Loyalty') :-
    buys(UserID, PreviousProd),
    same_brand(PreviousProd, TargetProd),
    \+ buys(UserID, TargetProd),
    user_intent_alignment(UserID, TargetProd).

semantic_recommendation(UserID, TargetProd, Reason) :-
    buys(UserID, BoughtProd),
    unpack_relation(BoughtProd, TargetProd, UnpackedType),
    \+ buys(UserID, TargetProd),
    \+ user_intent_alignment(UserID, TargetProd),
    atomic_list_concat(
        ['Based on previous purchases, this provides ', UnpackedType, '.'],
        Reason
    ).

explain_recommendation(UserID, ProdID, Explanation) :-
    semantic_recommendation(UserID, ProdID, Reason),
    product_name(ProdID, Name),
    agent(UserID, UserName, _),
    atomic_list_concat(
        ['Hello ', UserName, ', we suggest ', Name, '. Reason: ', Reason],
        Explanation
    ).

% ----------------------------------------------------------
% 4. DISCOUNT PRIORITIZATION
% ----------------------------------------------------------

% Revised weights: buys and also_buy dominate the decision.
weight_discount(mention, 1).
weight_discount(also_buy_category, 6).
weight_discount(previous_purchase_category, 5).

count_user_purchases_in_category(UserID, CatID, Count) :-
    findall(ProdID,
        (
            buys(UserID, ProdID),
            product_category(ProdID, CatID)
        ),
        ProdList),
    sort(ProdList, UniqueProdList),
    length(UniqueProdList, Count).

count_user_also_buy_targets_in_category(UserID, CatID, Count) :-
    findall(TargetProd,
        (
            buys(UserID, BoughtProd),
            related_also_buy(BoughtProd, TargetProd),
            product_category(TargetProd, CatID),
            \+ buys(UserID, TargetProd)
        ),
        ProdList),
    sort(ProdList, UniqueProdList),
    length(UniqueProdList, Count).

user_mentions_category(UserID, CatID) :-
    mentions(UserID, CatID).

% Revised semantics:
% A category is a candidate only when real behavioral evidence is available.
candidate_discount_category(UserID, CatID, BoughtCount, AlsoBuyCount) :-
    count_user_purchases_in_category(UserID, CatID, BoughtCount),
    count_user_also_buy_targets_in_category(UserID, CatID, AlsoBuyCount),
    (BoughtCount > 0 ; AlsoBuyCount > 0).

% Single consistent predicate for CQ2.
prioritized_discount_category(UserID, CatID, PriorityScore, MentionFlag, BoughtCount, AlsoBuyCount, Explanation) :-
    candidate_discount_category(UserID, CatID, BoughtCount, AlsoBuyCount),
    weight_discount(mention, MentionWeight),
    weight_discount(also_buy_category, AlsoBuyWeight),
    weight_discount(previous_purchase_category, BoughtWeight),
    ( user_mentions_category(UserID, CatID) ->
        MentionFlag = yes,
        MentionScore = MentionWeight
    ;
        MentionFlag = no,
        MentionScore = 0
    ),
    PriorityScore is MentionScore + (AlsoBuyCount * AlsoBuyWeight) + (BoughtCount * BoughtWeight),
    PriorityScore > 0,
    atomic_list_concat([
        'Category ', CatID,
        ' prioritized because mention=', MentionFlag,
        ', also_buy_candidates=', AlsoBuyCount,
        ', previous_purchases=', BoughtCount
    ], Explanation).

% ----------------------------------------------------------
% 5. BUNDLE DISCOUNT CANDIDATES
% ----------------------------------------------------------

weight_bundle(also_buy, 5).
weight_bundle(also_view, 3).
weight_bundle(same_brand, 2).
weight_bundle(same_category, 1).

candidate_bundle_pair(P1, P2) :-
    P1 @< P2,
    (
        related_also_buy(P1, P2) ;
        related_also_view(P1, P2) ;
        same_brand(P1, P2) ;
        same_category(P1, P2)
    ).

bundle_score(P1, P2, Score) :-
    weight_bundle(also_buy, WAlsoBuy),
    weight_bundle(also_view, WAlsoView),
    weight_bundle(same_brand, WBrand),
    weight_bundle(same_category, WCategory),
    ( related_also_buy(P1, P2) -> AlsoBuyScore = WAlsoBuy ; AlsoBuyScore = 0 ),
    ( related_also_view(P1, P2) -> AlsoViewScore = WAlsoView ; AlsoViewScore = 0 ),
    ( same_brand(P1, P2) -> BrandScore = WBrand ; BrandScore = 0 ),
    ( same_category(P1, P2) -> CategoryScore = WCategory ; CategoryScore = 0 ),
    Score is AlsoBuyScore + AlsoViewScore + BrandScore + CategoryScore.

bundle_explanation(P1, P2, Explanation) :-
    ( related_also_buy(P1, P2) -> AlsoBuyText = 'yes' ; AlsoBuyText = 'no' ),
    ( related_also_view(P1, P2) -> AlsoViewText = 'yes' ; AlsoViewText = 'no' ),
    ( same_brand(P1, P2) -> BrandText = 'yes' ; BrandText = 'no' ),
    ( same_category(P1, P2) -> CategoryText = 'yes' ; CategoryText = 'no' ),
    atomic_list_concat([
        'Bundle candidate because also_buy=', AlsoBuyText,
        ', also_view=', AlsoViewText,
        ', same_brand=', BrandText,
        ', same_category=', CategoryText
    ], Explanation).

bundle_discount_candidate(ProductID1, ProductName1, ProductID2, ProductName2, BundleScore, Explanation) :-
    candidate_bundle_pair(ProductID1, ProductID2),
    bundle_score(ProductID1, ProductID2, BundleScore),
    BundleScore > 0,
    product_name(ProductID1, ProductName1),
    product_name(ProductID2, ProductName2),
    bundle_explanation(ProductID1, ProductID2, Explanation).