import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../services/category_service.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  static bool isChanged = false;
  CategoryService categoryService = CategoryService();
  CategoryBloc() : super(CategoryState(List.empty())) {
    on<CategoriesALL>((event, emit) async {
      isChanged = false;
      final List<Category> categories =
          await categoryService.getCategory();
      emit(CategoryState(categories));
      isChanged = true;
    });
  }

  bool getConnexionStatus() {
    return isChanged;
  }
}

class CategoryState extends Equatable{
  final List<Category> categoryList;

  const CategoryState(this.categoryList);

  @override
  List<Object?> get props => [categoryList];
}

class InitialCategoryState extends CategoryState {
  const InitialCategoryState(super.categoryList);
}

class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Category> get props => [];
}

class CategoriesALL extends CategoryEvent {}
