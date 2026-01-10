import 'package:bizzmirth_app/services/api_service.dart';
import 'package:bizzmirth_app/utils/failure.dart';
import 'package:bizzmirth_app/utils/view_state.dart';
import 'package:flutter/material.dart';

class FranchiseeCuPayoutsController extends ChangeNotifier{
  final ApiService _apiService;
  FranchiseeCuPayoutsController({ApiService? apiService})
  : _apiService = apiService ?? ApiService();

    // ─────────────────────────────────────
  // State
  // ─────────────────────────────────────
  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  Failure? _failure;
  Failure? get failure => _failure;
}