import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app/resources/resources.dart';
import '../../di/di.dart';
import '../../domain/models/note/note_model.dart';
import '../home/cubit/beranda_notes_cubit.dart';
import '../home/cubit/beranda_notes_state.dart';

class NotesListScreen extends StatelessWidget {
  const NotesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<BerandaNotesCubit>()..loadNotes(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Catatan Saya',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.h),
            child: Container(color: Colors.grey.withAlpha(20), height: 1.h),
          ),
        ),
        body: BlocBuilder<BerandaNotesCubit, BerandaNotesState>(
          builder: (context, state) {
            if (state is BerandaNotesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BerandaNotesLoaded) {
              final notes = state.notes;
              if (notes.isEmpty) {
                return _buildEmptyState(context);
              }
              return _buildNotesList(context, notes);
            }
            return const Center(child: Text('Gagal mengambil catatan'));
          },
        ),
      ),
    );
  }

  Widget _buildNotesList(BuildContext context, List<NoteModel> notes) {
    return Stack(
      children: [
        ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return Container(
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.grey.withAlpha(10)),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(20.w),
                title: Row(
                  children: [
                    if (note.isPinned)
                      Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: const Icon(Icons.push_pin, size: 16, color: AppColors.islamicTeal),
                      ),
                    Expanded(
                      child: Text(
                        note.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    note.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14.sp,
                      height: 1.5,
                    ),
                  ),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.noteDetailRoute,
                    arguments: {'note': note},
                  ).then((_) {
                    context.read<BerandaNotesCubit>().loadNotes();
                  });
                },
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 40.h),
            child: _buildCreateButton(context),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Custom Illustration from code.html
          SizedBox(
            width: 192.r,
            height: 192.r,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background card (rotated)
                Transform.rotate(
                  angle: -6 * 3.14159 / 180,
                  child: Container(
                    width: 128.r,
                    height: 160.r,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: Colors.grey.withAlpha(50)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
                // Front card
                Container(
                  width: 128.r,
                  height: 160.r,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.grey.withAlpha(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(15),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 32.h,
                            width: double.infinity,
                            color: const Color(0xFFE8F682).withAlpha(127),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLine(1.0),
                                SizedBox(height: 12.h),
                                _buildLine(0.75),
                                SizedBox(height: 12.h),
                                _buildLine(1.0),
                                SizedBox(height: 12.h),
                                _buildLine(0.5),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 16.r,
                        right: 16.r,
                        child: Container(
                          width: 32.r,
                          height: 32.r,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2F9E84),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                // Decorative elements
                Positioned(
                  top: 0,
                  right: 16.r,
                  child: Container(
                    width: 16.r,
                    height: 16.r,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F682).withAlpha(150),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 32.r,
                  left: 16.r,
                  child: Transform.rotate(
                    angle: 12 * 3.14159 / 180,
                    child: Container(
                      width: 24.r,
                      height: 24.r,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2F9E84).withAlpha(50),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),
          Text(
            'Belum ada catatan.',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tulis hikmah atau doa penting di sini.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
              height: 1.5,
            ),
          ),
          SizedBox(height: 40.h),
          _buildCreateButton(context),
        ],
      ),
    );
  }

  Widget _buildLine(double widthFactor) {
    return Container(
      height: 6.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(30),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: widthFactor,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(30),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, Routes.noteDetailRoute).then((_) {
          context.read<BerandaNotesCubit>().loadNotes();
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2F9E84),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
        elevation: 10,
        shadowColor: const Color(0xFF2F9E84).withAlpha(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.add, weight: 700),
          SizedBox(width: 8.w),
          Text(
            'Buat Catatan Baru',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
