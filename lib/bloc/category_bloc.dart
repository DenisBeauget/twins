import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../services/category_service.dart';
import '../utils/toaster.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryService categoryService = CategoryService();
  CategoryBloc() : super(CategoryInitialState()) {
    on<CategoriesALL>((event, emit) async {
      emit(CategoryLoading());
      final List<Category> categories = await categoryService.getCategory();
      emit(CategoryLoaded(categories));
    });

    on<AddCategory>((event, emit) async {
      if (state is CategoryLoaded) {
        final List<Category> categories =
            (state as CategoryLoaded).categoryList;
        await categoryService
            .addCategory(event.category)
            .then((value) => {
                  if (value)
                    {
                      emit(CategoryLoading()),
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
            .whenComplete(() => emit(CategoryLoaded(categories)));
      }
    });

    on<DeleteCategory>((event, emit) async {
      final List<Category> categories = (state as CategoryLoaded).categoryList;
      await categoryService.deleteCategory(event.category.name).then((value) {
        if (value) {
          if (categories.map((e) => e.name == event.category.name) != null) {
            emit(CategoryLoading());
            categories.removeWhere((e) => e.name == event.category.name);
            Toaster.showSuccessToast(
                event.context,
                AppLocalizations.of(event.context)!
                    .admin_category_deleted_message);
          } else {
            Toaster.showFailedToast(event.context,
                AppLocalizations.of(event.context)!.category_not_found);
          }
        } else {
          Toaster.showFailedToast(
              event.context, AppLocalizations.of(event.context)!.delete_error);
        }
      }).whenComplete(() => emit(CategoryLoaded(categories)));
    });

    on<CategoriesRefresh>((event, emit) async {
      final List<Category> categories = (state as CategoryLoaded).categoryList;
      emit(CategoryLoaded(categories));
    });
  }
}

class CategoryState {}

class CategoryInitialState extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categoryList;

  CategoryLoaded(this.categoryList);
}

class CategoryLoading extends CategoryState {}

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

class CategoriesRefresh extends CategoryEvent {
  const CategoriesRefresh();
}
