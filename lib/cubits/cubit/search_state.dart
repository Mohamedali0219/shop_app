part of 'search_cubit.dart';

sealed class SearchStates {}

final class SearchInitialState extends SearchStates {}

final class SearchLoadingState extends SearchStates {}

final class SearchSuccessState extends SearchStates {}

final class SearchErrorState extends SearchStates {}
