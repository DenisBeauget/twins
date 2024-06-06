import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../services/category_service.dart';
import '../utils/toaster.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    on<AddCategory>((event, emit) async {
      isChanged = false;
      final List<Category> categories = state.categoryList;
      await categoryService
          .addCategory(event.category)
          .then((value) => {
                print(value),
                if (value)
                  {
                    categories.add(event.category),
                    Toaster.showSuccessToast(event.context,
                        AppLocalizations.of(event.context)!.category_added),
                  }
                else
                  {
                    Toaster.showFailedToast(
                        event.context,
                        AppLocalizations.of(event.context)!
                            .category_already_exist)
                  },
              })
          .whenComplete(() => emit(CategoryState(categories)));
      isChanged = true;
    });

    on<DeleteCategory>((event, emit) async {
      isChanged = false;
      final List<Category> categories = state.categoryList;
      await categoryService.deleteCategory(event.category.name).then((value) {
        if (value) {
          if (categories.map((e) => e.name == event.category.name) != null) {
            categories.removeWhere((e) => e.name == event.category.name);
            Toaster.showSuccessToast(event.context, "Catégorie supprimé");
            print(categories.toString());
          } else {
            Toaster.showFailedToast(event.context, "Catégorie introuvable");
          }
        } else {
          Toaster.showFailedToast(
              event.context, "Erreur lors de la suppression");
        }
      }).whenComplete(() => emit(CategoryState(categories)));
      isChanged = true;
    });

    on<CategoryManuallySet>((event, emit) async {
      isChanged = false;
      emit(CategoryState(event.categories));
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

class AddCategory extends CategoryEvent {
  final Category category;
  final BuildContext context;

  const AddCategory(this.category, this.context);
}

class DeleteCategory extends CategoryEvent {
  final Category category;
  final BuildContext context;

  const DeleteCategory(this.category, this.context);
}

class CategoryManuallySet extends CategoryEvent {
  final List<Category> categories;

  const CategoryManuallySet(this.categories);
}
