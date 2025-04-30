import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../generated/l10n.dart';
import 'tabs/add_exam_tab.dart';
import 'tabs/completed_exams_tab.dart';

class ExamsPage extends ConsumerStatefulWidget {
  const ExamsPage({super.key});

  @override
  ConsumerState<ExamsPage> createState() => _ExamsPageState();
}

class _ExamsPageState extends ConsumerState<ExamsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(S.of(context).examManagement),
              bottom: TabBar(
                tabs: [
                  Tab(text: S.of(context).addExam),
                  Tab(text: S.of(context).completedExams),
                ],
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Theme.of(context).disabledColor,
                indicatorColor: Theme.of(context).primaryColor,
                dividerColor: Colors.transparent,
              ),
            ),
            body: TabBarView(
              children: [
                AddExamTab(),
                CompletedExamsTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
