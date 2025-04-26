import 'package:flutter/material.dart';

import 'package:start_invest/models/loan_step_model.dart';

class Steps extends StatelessWidget {
  Steps({super.key});

  final List<LoanStep> loanSteps = [
    LoanStep(
      title: "Choose Loan",
      description:
          "Select the right type of loan based on your startup or business requirements.",
    ),
    LoanStep(
      title: "Check Eligibility",
      description:
          "Review eligibility criteria like business turnover, credit score, and operational history.",
    ),
    LoanStep(
      title: "Prepare Documents",
      description:
          "Gather all necessary documents such as ID proof, business registration, bank statements, and tax returns.",
    ),
    LoanStep(
      title: "Apply Online/Branch",
      description:
          "Submit your loan application through the bank's online portal or by visiting a nearby branch.",
    ),
    LoanStep(
      title: "Verification & Approval",
      description:
          "Bank officials verify your documents and creditworthiness before approving the loan.",
    ),
    LoanStep(
      title: "Disbursement",
      description:
          "Upon agreement signing, the loan amount is transferred to your registered bank account.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: loanSteps.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              "Steps to apply for loans:",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          );
        }
        final step = loanSteps[index - 1];
        return _SingleStep(index, step);
      },
    );
  }
}

class _SingleStep extends StatefulWidget {
  const _SingleStep(this.index, this.loanStep);

  final LoanStep loanStep;
  final int index;

  @override
  State<_SingleStep> createState() => _SingleStepState();
}

class _SingleStepState extends State<_SingleStep> {
  bool isExpanded = false;

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: toggleExpanded,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.index}. ${widget.loanStep.title}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.keyboard_arrow_down_rounded),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                widget.loanStep.description,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            crossFadeState:
                isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
