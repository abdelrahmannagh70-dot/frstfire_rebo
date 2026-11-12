import 'package:app3/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/checkout_model.dart';
import '../checkout_cubit.dart';


class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _email = TextEditingController();
  int? _governorateId;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _email.dispose();
    super.dispose();
  }

  bool get _isComplete =>
      _name.text.trim().isNotEmpty &&
          _phone.text.trim().isNotEmpty &&
          _address.text.trim().isNotEmpty &&
          _governorateId != null;

  String _govName(List<GovernorateModel> list) {
    for (final g in list) {
      if (g.id == _governorateId) return g.name;
    }
    return '';
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? const Color(0xFFE53935) : null,
      ),
    );
  }

  void _onOrder(CheckoutCubit cubit) {
    if (!_isComplete) {
      _snack('Please add your delivery address first', error: true);
      _openAddressSheet(cubit.governorates);
      return;
    }
    cubit.placeOrder(
      governorateId: _governorateId!,
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      address: _address.text.trim(),
      email: _email.text.trim(),
    );
  }

  void _openAddressSheet(List<GovernorateModel> governorates) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(
            16.w,
            20.h,
            16.w,
            MediaQuery.of(sheetContext).viewInsets.bottom + 20.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Delivery Address',
                  style: TextStyle(
                    fontFamily: 'DM',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                16.verticalSpace,
                _field(_name, 'Full Name'),
                12.verticalSpace,
                _field(_phone, 'Phone', type: TextInputType.phone),
                12.verticalSpace,
                _field(_email, 'Email (optional)',
                    type: TextInputType.emailAddress),
                12.verticalSpace,
                DropdownButtonFormField<int>(
                  value: _governorateId,
                  decoration: _decoration('Governorate'),
                  items: governorates
                      .map((g) => DropdownMenuItem<int>(
                    value: g.id,
                    child: Text(g.name),
                  ))
                      .toList(),
                  onChanged: (v) {
                    setState(() => _governorateId = v);
                    setSheet(() {});
                  },
                ),
                12.verticalSpace,
                _field(_address, 'Address'),
                20.verticalSpace,
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(sheetContext);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label,
      {TextInputType? type}) =>
      TextField(
        controller: c,
        keyboardType: type,
        decoration: _decoration(label),
      );

  InputDecoration _decoration(String label) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: AppColors.bgColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(color: AppColors.borderColor),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<CheckoutCubit, CheckoutState>(
          listener: (context, state) {
            final cubit = context.read<CheckoutCubit>();
            if (state is CheckoutLoaded) {
              final c = cubit.checkout!;
              _name.text = c.userName;
              _phone.text = c.phone ?? '';
              _address.text = c.address ?? '';
            } else if (state is PlaceOrderSuccess) {
              _snack('Order placed successfully');
              Navigator.pop(context);
            } else if (state is PlaceOrderError) {
              _snack(state.message, error: true);
            }
          },
          builder: (context, state) {
            final cubit = context.read<CheckoutCubit>();

            if (state is CheckoutLoading) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.mainColor),
              );
            }
            if (state is CheckoutError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.message, textAlign: TextAlign.center),
                      16.verticalSpace,
                      ElevatedButton(
                        onPressed: cubit.load,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              );
            }
            final checkout = cubit.checkout;
            if (checkout == null) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.mainColor),
              );
            }
            return _body(cubit, checkout, state is PlaceOrderLoading);
          },
        ),
      ),
    );
  }

  Widget _body(CheckoutCubit cubit, CheckoutModel checkout, bool placing) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          12.verticalSpace,
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(Icons.arrow_back_ios_new, size: 16.sp),
                ),
              ),
              const Spacer(),
              Text(
                'Checkout',
                style: TextStyle(
                  fontFamily: 'DM',
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              SizedBox(width: 36.w),
            ],
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                20.verticalSpace,
                Text(
                  'Delivery Address',
                  style: TextStyle(
                    fontFamily: 'DM',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                12.verticalSpace,
                Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: AppColors.bgColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isComplete) ...[
                        Text(
                          _name.text,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        6.verticalSpace,
                        Text(
                          '${_address.text}, ${_govName(cubit.governorates)}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.darkGrayColor,
                          ),
                        ),
                        4.verticalSpace,
                        Text(
                          _phone.text,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.darkGrayColor,
                          ),
                        ),
                      ] else
                        Text(
                          'No delivery address yet',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.darkGrayColor,
                          ),
                        ),
                      10.verticalSpace,
                      OutlinedButton.icon(
                        onPressed: () =>
                            _openAddressSheet(cubit.governorates),
                        icon: Icon(Icons.edit_outlined,
                            size: 16.sp, color: AppColors.mainColor),
                        label: Text(
                          _isComplete ? 'Edit Address' : 'Add Address',
                          style: TextStyle(color: AppColors.mainColor),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.mainColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                16.verticalSpace,
                Divider(color: AppColors.borderColor),
                10.verticalSpace,
                Text(
                  'Items (${checkout.items.length})',
                  style: TextStyle(
                    fontFamily: 'DM',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                10.verticalSpace,
                if (checkout.items.isEmpty)
                  const Text('Your cart is empty')
                else
                  ...checkout.items.map(_itemRow),
                20.verticalSpace,
                Text(
                  'Payment Summary',
                  style: TextStyle(
                    fontFamily: 'DM',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                12.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total',
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.bold)),
                    Text(
                      '\$${checkout.total}',
                      style: TextStyle(
                        fontFamily: 'DM',
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainColor,
                      ),
                    ),
                  ],
                ),
                24.verticalSpace,
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: (placing || checkout.items.isEmpty)
                  ? null
                  : () => _onOrder(cubit),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: placing
                  ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : Text(
                'Order',
                style: TextStyle(
                  fontFamily: 'DM',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          16.verticalSpace,
        ],
      ),
    );
  }

  Widget _itemRow(CheckoutItemModel item) => Container(
    margin: EdgeInsets.only(bottom: 10.h),
    padding: EdgeInsets.all(12.r),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: AppColors.borderColor),
    ),
    child: Row(
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: AppColors.bgColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(Icons.menu_book_outlined,
              color: AppColors.mainColor, size: 24.sp),
        ),
        12.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: TextStyle(
                    fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              4.verticalSpace,
              Text(
                '\$${item.total}',
                style: TextStyle(
                    fontSize: 13.sp, color: AppColors.mainColor),
              ),
            ],
          ),
        ),
        Text('x${item.quantity}',
            style: TextStyle(
                fontSize: 14.sp, fontWeight: FontWeight.w600)),
      ],
    ),
  );
}