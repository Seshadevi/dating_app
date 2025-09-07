import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/signupprocessProviders/choosr_foodies_provider.dart';
import 'package:dating/provider/signupprocessProviders/genderProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// imports
import 'package:dating/provider/loader.dart';

// ⬇️ adjust these imports to your project structure
import 'package:dating/provider/loginProvider.dart';


import 'package:dating/screens/completeprofile/moreaboutyou_screens/languagesscreen.dart';

/// Data object returned to the caller on "Apply"
class SearchFilters {
  final int? genderId;               // null = Everyone
  final int minAge;
  final int maxAge;
  final bool relaxAge;

  final double maxDistanceKm;
  final bool relaxDistance;

  final Set<int> interestIds;        // dynamic interests (IDs)
  final bool verifiedOnly;

  // Keep names for now; swap to IDs when your languages picker returns IDs
  final List<String> languageNames;

  final int minHeightCm;
  final int maxHeightCm;
  final bool relaxHeight;

  final List<String> relationship;   // keep as strings for now

  const SearchFilters({
    required this.genderId,
    required this.minAge,
    required this.maxAge,
    required this.relaxAge,
    required this.maxDistanceKm,
    required this.relaxDistance,
    required this.interestIds,
    required this.verifiedOnly,
    required this.languageNames,
    required this.minHeightCm,
    required this.maxHeightCm,
    required this.relaxHeight,
    required this.relationship,
  });
}

class NarrowSearchScreen extends ConsumerStatefulWidget {
  const NarrowSearchScreen({super.key});

  @override
  ConsumerState<NarrowSearchScreen> createState() => _NarrowSearchScreenState();
}

class _NarrowSearchScreenState extends ConsumerState<NarrowSearchScreen> {
  String activeFilter = 'basic';

  // ----- core state (basic)
  int? selectedGenderId; // null = Everyone
  RangeValues ageRangeValues = const RangeValues(18, 27);
  bool seeYounger = true;

  double distance = 80.0;
  bool seeDistant = true;

  // interests (IDs)
  final Set<int> selectedInterestIds = {};
  bool showOtherInterests = false;
  String interestsQuery = '';

  bool verified = true;

  // languages (names for now)
  List<String> selectedLanguages = [];

  // ----- advanced
  RangeValues heightRange = const RangeValues(140, 200);
  bool showOtherHeight = false;

  List<String> selectedRelationshipOptions = [];
  bool showOtherRelationship = false;
  


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // preload gender list if empty
      final gState = ref.read(genderProvider);
      if ((gState.data ?? []).isEmpty) {
        await ref.read(genderProvider.notifier).getGender();
      }

      // preload interests list if empty
      final iState = ref.read(interestsProvider);
      if ((iState.data ?? []).isEmpty) {
        await ref.read(interestsProvider.notifier).getInterests();
      }

      // preselect from login model
      final login = ref.read(loginProvider);
      final user = (login.data?.isNotEmpty ?? false) ? login.data!.first.user : null;
        

      // gender identity: pick first selected
      final firstGender = user?.genderIdentities?.isNotEmpty == true
          ? user!.genderIdentities!.first
          : null;
      selectedGenderId = firstGender?.id; // null -> Everyone

      // interests from user (IDs)
      final uInterests = user?.interests ?? [];
      for (final it in uInterests) {
        if (it.id != null) selectedInterestIds.add(it.id!);
      }

      // languages (you currently pass names — this keeps it)
      // If your login model stores languages, prefill here.

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final genders = ref.watch(genderProvider).data ?? [];
    final interestsState = ref.watch(interestsProvider);
    final allInterests = interestsState.data ?? [];
      // OPTION A: use your global loader
    final bool interestsLoading = ref.watch(loadingProvider);
    final filteredInterests = interestsQuery.trim().isEmpty
        ? allInterests
        : allInterests
            .where((d) => (d.interests ?? '')
                .toLowerCase()
                .contains(interestsQuery.toLowerCase()))
            .toList();

     final user = ref.watch(loginProvider).data?.first.user;
         final languageNamesFromModel = (user?.spokenLanguages ?? [])
          .map((l) => l.name)
          .whereType<String>()
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();        

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Narrow Your Search',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // tabs
          Container(
            margin: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => activeFilter = 'basic'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: activeFilter == 'basic' ? DatingColors.everqpidColor : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Basic Filter',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: activeFilter == 'basic' ? Colors.white : Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => activeFilter = 'advanced'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: activeFilter == 'advanced' ? DatingColors.everqpidColor : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Advanced Filter',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: activeFilter == 'advanced' ? Colors.white : Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: activeFilter == 'basic'
                  ? _buildBasicFilter(genders, interestsLoading , filteredInterests,languageNamesFromModel)
                  : _buildAdvancedFilter(),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- BASIC FILTER ----------
  Widget _buildBasicFilter(
    List<dynamic> genders,
    bool interestsLoading,
    List<dynamic> filteredInterests,
    List<dynamic> languageNamesFromModel
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Who Would You Like To Date?'),
        _buildGenderDropdown(genders),
        const SizedBox(height: 20),

        _buildSectionTitle('keep choose your age preference '),
        _buildAgeRangeSelector(),
        const SizedBox(height: 20),

        _buildSectionTitle('How Far Away Are They?'),
        _buildDistanceSelector(),
        const SizedBox(height: 20),

        _buildSectionTitle('Do They Share Any Of Your Interests?'),
        _buildDynamicInterestsSection(interestsLoading, filteredInterests),
        const SizedBox(height: 20),

        buildVerifiedSection(
          verified: verified,
          onToggleChanged: (v) => setState(() => verified = v),
          onInfoTap: () {},
        ),
        const SizedBox(height: 20),

        _buildSectionTitle('Which Languages Do They Know?'),
        GestureDetector(
          onTap: () async {
            final selected = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LanguageSelectionScreen(),
              ),
            );
            if (selected is List<String>) {
              setState(() => selectedLanguages = selected);
            }
          },
          child: _buildSelectionContainer(
            languageNamesFromModel.isEmpty
        ? 'Select Languages'
        : languageNamesFromModel.join(', '),
          ),
        ),

        const SizedBox(height: 20),
        _applyButton(),
      ],
    );
  }

  // ---------- ADVANCED FILTER ----------
  Widget _buildAdvancedFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeightSelector(
          heightRange: heightRange,
          showOtherHeight: showOtherHeight,
          onRangeChanged: (RangeValues newRange) => setState(() => heightRange = newRange),
          onToggleChanged: (bool value) => setState(() => showOtherHeight = value),
        ),
        const SizedBox(height: 20),

        buildRelationshipSelector(
          selectedOptions: selectedRelationshipOptions,
          onSelectionChanged: (newList) => setState(() => selectedRelationshipOptions = newList),
          showOtherOptions: showOtherRelationship,
          onToggleChanged: (value) => setState(() => showOtherRelationship = value),
        ),
        const SizedBox(height: 20),

        // Examples of additional filters (you can keep your ExpandableFilter components)
        ExpandableFilter(
          title: "What Are Their Family Plans?",
          options: const ["Don’t want kids", "Open to kids", "Want kids", "Not sure"],
        ),
        ExpandableFilter(
          title: "Do They Have Kids?",
          options: const ["Have kids", "Don't have kids"],
        ),
        ExpandableFilter(
          title: "What's Their Religion?",
          options: const [
            "Agnostic","Atheist","Buddhist","Catholic","Christian","Hindu",
            "Jain","Jewish","Mormon","Latter-day Saint","Muslim"
          ],
        ),
        ExpandableFilter(
          title: "What's Their Education Level?",
          options: const [
            "High school","Vocational school","In college",
            "Undergraduate degree","In grad school","Graduate degree"
          ],
        ),
        ExpandableFilter(
          title: "What Are Their Political Views?",
          options: const ["Apolitical","Moderate","Left","Right","Communist","Socialist"],
        ),
        ExpandableFilter(
          title: "Do They Exercise?",
          options: const ["Active","Sometimes","Almost never"],
        ),

        const SizedBox(height: 30),
        _applyButton(),
      ],
    );
  }

  // ---------- UI pieces ----------

  Widget _applyButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [DatingColors.everqpidColor, DatingColors.everqpidColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        onPressed: _apply,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: const Text(
          'Apply',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[800]),
      ),
    );
  }

  Widget _buildGenderDropdown(List<dynamic> genders) {
    // Build items from provider; include an "Everyone" choice (null id)
    final items = <DropdownMenuItem<int?>>[
      const DropdownMenuItem<int?>(
        value: null,
        child: Text('Everyone'),
      ),
      ...genders.map((g) {
        final id = g.id as int?;
        final label = g.value as String? ?? '—';
        return DropdownMenuItem<int?>(
          value: id,
          child: Text(label),
        );
      }),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: DatingColors.everqpidColor, width: 1),
      ),
      child: DropdownButtonFormField<int?>(
        value: selectedGenderId,
        isExpanded: true,
        decoration: const InputDecoration(border: InputBorder.none),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
        items: items,
        onChanged: (val) => setState(() => selectedGenderId = val),
      ),
    );
  }

  Widget _buildAgeRangeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: DatingColors.everqpidColor, width: 1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Between ${ageRangeValues.start.round()} And ${ageRangeValues.end.round()}',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 8),
          RangeSlider(
            values: ageRangeValues,
            min: 18,
            max: 60,
            divisions: 42,
            activeColor: DatingColors.everqpidColor,
            inactiveColor: Colors.grey[300],
            onChanged: (v) => setState(() => ageRangeValues = v),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  'See people ~2 years either side if I run out',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Switch(
                value: seeYounger,
                onChanged: (v) => setState(() => seeYounger = v),
                activeColor: Colors.white,
                activeTrackColor: DatingColors.everqpidColor,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: DatingColors.everqpidColor, width: 1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Up To ${distance.round()} Kilometres Away',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          Slider(
            value: distance,
            min: 10,
            max: 200,
            divisions: 19,
            label: '${distance.round()} km',
            onChanged: (v) => setState(() => distance = v),
            activeColor: DatingColors.everqpidColor,
            inactiveColor: Colors.grey[300],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  'Show people a bit farther if I run out',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              Switch(
                value: seeDistant,
                onChanged: (v) => setState(() => seeDistant = v),
                activeColor: Colors.white,
                activeTrackColor: DatingColors.everqpidColor,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey[300],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDynamicInterestsSection(bool loading, List<dynamic> filteredInterests) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: DatingColors.everqpidColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filter By Your Interest', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),

          // optional search
          TextField(
            onChanged: (t) => setState(() => interestsQuery = t),
            decoration: InputDecoration(
              hintText: 'Search interests',
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),

          if (loading)
            const Center(child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: CircularProgressIndicator(),
            ))
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final item in filteredInterests)
                  _interestChoiceChip(item.id as int?, item.interests as String? ?? ''),
              ],
            ),
          const SizedBox(height: 16),

          const Text(
            "We'll try to show you people who share any one of the interests you select.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            height: 1,
            color: DatingColors.everqpidColor,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  'Show other people if\nI run out',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              Switch(
                value: showOtherInterests,
                onChanged: (v) => setState(() => showOtherInterests = v),
                activeColor: Colors.white,
                activeTrackColor: DatingColors.everqpidColor,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey[300],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _interestChoiceChip(int? id, String label) {
    final safeId = id ?? -1;
    final selected = selectedInterestIds.contains(safeId);

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() {
        if (selected) {
          selectedInterestIds.remove(safeId);
        } else {
          selectedInterestIds.add(safeId);
        }
      }),
      selectedColor:DatingColors.everqpidColor,
      side: const BorderSide(color: DatingColors.everqpidColor),
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Color.fromARGB(255, 44, 42, 42),
      ),
    );
  }

  // ---------- Existing helpers (slightly tweaked) ----------

  Widget buildVerifiedSection({
    required bool verified,
    required ValueChanged<bool> onToggleChanged,
    required VoidCallback onInfoTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title + Info link
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Have They Verified \nThemselves?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            GestureDetector(
              onTap: onInfoTap,
              child: const Text(
                'What Is This?',
                style: TextStyle(fontSize: 14, decoration: TextDecoration.underline, color: Colors.black),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Toggle Row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: DatingColors.everqpidColor),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text('Verified Only', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  SizedBox(width: 8),
                  Icon(Icons.verified, color: DatingColors.everqpidColor, size: 20),
                ],
              ),
              Switch(
                value: verified,
                onChanged: onToggleChanged,
                activeColor: Colors.white,
                activeTrackColor: DatingColors.everqpidColor,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey[300],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionContainer(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: DatingColors.everqpidColor, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: text == 'Select Languages' ? Colors.grey[500] : Colors.grey[700],
                fontSize: 16,
              ),
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget buildHeightSelector({
    required RangeValues heightRange,
    required bool showOtherHeight,
    required ValueChanged<RangeValues> onRangeChanged,
    required ValueChanged<bool> onToggleChanged,
  }) {
    final isFullRange = heightRange.start == 140 && heightRange.end == 200;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('How Tall Are They?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: DatingColors.everqpidColor),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isFullRange
                    ? 'Any Height Is Just Fine'
                    : '${heightRange.start.round()} cm - ${heightRange.end.round()} cm',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              RangeSlider(
                values: heightRange,
                min: 140,
                max: 200,
                labels: RangeLabels(
                  '${heightRange.start.round()}',
                  '${heightRange.end.round()}',
                ),
                onChanged: onRangeChanged,
                activeColor: DatingColors.everqpidColor,
                inactiveColor: Colors.grey[300],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Show Other People If I\nRun Out', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  Switch(
                    value: showOtherHeight,
                    onChanged: onToggleChanged,
                    activeColor: Colors.white,
                    activeTrackColor: DatingColors.everqpidColor,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey[300],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildRelationshipSelector({
    required List<String> selectedOptions,
    required ValueChanged<List<String>> onSelectionChanged,
    required bool showOtherOptions,
    required ValueChanged<bool> onToggleChanged,
  }) {
    final List<String> options = [
      'A Long - Term Relationship',
      'Fun, Casual Dates',
      'Marriage',
      'Intimacy, Without Commitment',
      'A Life Partner',
      'Ethical Non-Monogamy',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('What Are They Looking For?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: DatingColors.everqpidColor),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              ...options.map((option) {
                final isSelected = selectedOptions.contains(option);
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        final updated = List<String>.from(selectedOptions);
                        isSelected ? updated.remove(option) : updated.add(option);
                        onSelectionChanged(updated);
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            value: isSelected,
                            onChanged: (_) {
                              final updated = List<String>.from(selectedOptions);
                              isSelected ? updated.remove(option) : updated.add(option);
                              onSelectionChanged(updated);
                            },
                            activeColor: DatingColors.everqpidColor,
                          ),
                          Expanded(child: Text(option, style: const TextStyle(fontSize: 15))),
                        ],
                      ),
                    ),
                    if (option != options.last)
                      const Divider(color: DatingColors.everqpidColor, thickness: 1, height: 0),
                  ],
                );
              }).toList(),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Show Other People If I\nRun Out',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  Switch(
                    value: showOtherOptions,
                    onChanged: onToggleChanged,
                    activeColor: Colors.white,
                    activeTrackColor: DatingColors.everqpidColor,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey[300],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------- APPLY ----------
  void _apply() {
  final user = ref.read(loginProvider).data?.first.user;
  final defaultLangs = (user?.spokenLanguages ?? [])
      .map((l) => l.name)
      .whereType<String>()
      .where((s) => s.trim().isNotEmpty)
      .toList();

  final filters = SearchFilters(
    genderId: selectedGenderId,
    minAge: ageRangeValues.start.round(),
    maxAge: ageRangeValues.end.round(),
    relaxAge: seeYounger,
    maxDistanceKm: distance,
    relaxDistance: seeDistant,
    interestIds: selectedInterestIds,
    verifiedOnly: verified,
    languageNames: selectedLanguages.isNotEmpty ? selectedLanguages : defaultLangs,
    minHeightCm: heightRange.start.round(),
    maxHeightCm: heightRange.end.round(),
    relaxHeight: showOtherHeight,
    relationship: selectedRelationshipOptions,
  );

  Navigator.pop(context, filters);
}

}

// ---------- ExpandableFilter (unchanged behavior) ----------
class ExpandableFilter extends StatefulWidget {
  final String title;
  final List<String> options;

  const ExpandableFilter({
    required this.title,
    required this.options,
    super.key,
  });

  @override
  State<ExpandableFilter> createState() => _ExpandableFilterState();
}

class _ExpandableFilterState extends State<ExpandableFilter> {
  bool isExpanded = false;
  bool showOthers = false;
  Set<String> selectedOptions = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
          child: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        GestureDetector(
          onTap: () => setState(() => isExpanded = !isExpanded),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: DatingColors.everqpidColor),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Add This Filter', style: TextStyle(fontSize: 15, color: Colors.black87)),
                Icon(Icons.add, color: DatingColors.everqpidColor),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                const Divider(),
                ...widget.options.map((option) => CheckboxListTile(
                      value: selectedOptions.contains(option),
                      activeColor: DatingColors.everqpidColor,
                      title: Text(option),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            selectedOptions.add(option);
                          } else {
                            selectedOptions.remove(option);
                          }
                        });
                      },
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Show other people if I run out", style: TextStyle(color: Colors.grey[600])),
                    Switch(
                      value: showOthers,
                      onChanged: (val) => setState(() => showOthers = val),
                      activeColor: Colors.white,
                      activeTrackColor: DatingColors.everqpidColor,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey[300],
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}










































// import 'package:dating/screens/profile_screens/languagesScreen.dart';
// import 'package:dating/screens/completeprofile/moreaboutyou_screens/languagesscreen.dart';
// import 'package:flutter/material.dart';

// class NarrowSearchScreen extends StatefulWidget {
//   @override
//   _NarrowSearchScreenState createState() => _NarrowSearchScreenState();
// }

// class _NarrowSearchScreenState extends State<NarrowSearchScreen> {
//   String activeFilter = 'basic';
  
//   // Filter states
//   String gender = 'Women';
//   String ageRange = 'Between 18 And 27';
//   bool seeYounger = true;
//   double distance = 80.0;
//   bool seeDistant = true;
//   List<String> interests = ['Festivals', 'Gardening', 'Coffee', 'Dog'];
//   bool showOtherInterests = false;

//   bool verified = true;
//   List<String> selectedLanguages = [];
//   RangeValues heightRange = RangeValues(140, 200);
  
  
//   // Advanced filter states
//   String height = 'Any Height Is Just Fine';
//   bool showOtherHeight = false;
//   String relationshipType = 'A Long - Term Relationship';
//   List<String> selectedRelationshipOptions = [];
//   bool showOtherRelationship = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.close, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Narrow Your Search',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           // Filter Tabs
//           Container(
//             margin: EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () => setState(() => activeFilter = 'basic'),
//                     child: Container(
//                       padding: EdgeInsets.symmetric(vertical: 12),
//                       decoration: BoxDecoration(
//                         color: activeFilter == 'basic' ?Color(0xFF434F11)
//                : Colors.grey[200],
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         'Basic Filter',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: activeFilter == 'basic' ? Colors.white : Colors.grey[700],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 4),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () => setState(() => activeFilter = 'advanced'),
//                     child: Container(
//                       padding: EdgeInsets.symmetric(vertical: 12),
//                       decoration: BoxDecoration(
//                         color: activeFilter == 'advanced' ? Color(0xFF434F11)
//                         : Colors.grey[200],
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         'Advanced Filter',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: activeFilter == 'advanced' ? Colors.white : Colors.grey[700],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Divider(),
//           // Filter Content
//           Expanded(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.all(16),
//               child: activeFilter == 'basic' ? _buildBasicFilter() : _buildAdvancedFilter(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBasicFilter() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Gender Selection
//         _buildSectionTitle('Who Would You Like To Date?'),
//         _buildGenderDropdown(),
//         SizedBox(height: 20),

//         // Age Range
//         _buildSectionTitle('How Old Are They?'),
//         // _buildSelectionContainer(ageRange),
//         _buildAgeRangeSelector(),
//         // SizedBox(height: 8),
//         // _buildToggleRow('See People 2 Years Either Side If I Run Out', seeYounger, (value) {
//         //   setState(() => seeYounger = value);
//         // }),
//         SizedBox(height: 20),

//        _buildSectionTitle('How Far Away Are They?'),
//         buildDistanceSelector(
//           distance: distance,
//           seeDistant: seeDistant,
//           onSliderChange: (val) => setState(() => distance = val),
//           onToggleChange: (val) => setState(() => seeDistant = val),
//         ),

//         SizedBox(height: 20),

//        _buildSectionTitle('Do They Share Any Your Interest?'),
//         buildInterestsSection(
//           interests: interests,
//           showOtherInterests: showOtherInterests,
//           onToggleChanged: (val) => setState(() => showOtherInterests = val),
//         ),
//         SizedBox(height: 20),

//         // Verification
//        buildVerifiedSection(
//           verified: verified,
//           onToggleChanged: (value) {
//             setState(() {
//               verified = value;
//             });
//           },
//           onInfoTap: () {
//             // TODO: Show popup or explanation
//             print('What Is This? tapped');
//           },
//         ),

        
//         SizedBox(height: 20),

//         // Languages
//         _buildSectionTitle('Which Languages Do They Know?'),
//           GestureDetector(
//             onTap: () async {
//               final selected = await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => LanguageSelectionScreen(
//                     // selectedLanguages: selectedLanguages, // maintain this in your state
//                   ),
//                 ),
//               );

//               if (selected != null) {
//                 setState(() {
//                   selectedLanguages = selected;
//                 });
//               }
//             },
//             child: _buildSelectionContainer(
//               selectedLanguages.isEmpty ? 'Select Languages' : selectedLanguages.join(', '),
//             ),
//           ),
//          // Apply Button
//          SizedBox(height: 20),
//         Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFF869E23), Color(0xFF000000)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//           borderRadius: BorderRadius.circular(30),
//         ),
//         child: ElevatedButton(
//           onPressed: () {},
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.transparent, // Make button background transparent
//             shadowColor: Colors.transparent,     // Remove elevation shadow
//             padding: EdgeInsets.symmetric(vertical: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           child: Text(
//             'Apply',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w500,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),

//       ],
//     );
//   }

//   Widget _buildAdvancedFilter() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Height
//         // _buildSectionTitle('How Tall Are They?'),
//         buildHeightSelector(
//               heightRange: heightRange,
//               showOtherHeight: showOtherHeight,
//               onRangeChanged: (RangeValues newRange) {
//                 setState(() => heightRange = newRange);
//               },
//               onToggleChanged: (bool value) {
//                 setState(() => showOtherHeight = value);
//               },
//             ),


//         // _buildSelectionContainer(height),
//         // SizedBox(height: 8),
//         // _buildToggleRow('Show Other People If I Run Out', showOtherHeight, (value) {
//         //   setState(() => showOtherHeight = value);
//         // }),
//         SizedBox(height: 20),

//         // Relationship Type
//         // _buildSectionTitle('What Are They Looking For?'),
//         // _buildRelationshipOptions(),
//         // SizedBox(height: 8),
//         // _buildToggleRow('Show Other People If I Run Out', false, (value) {}),
//         buildRelationshipSelector(
//           selectedOptions: selectedRelationshipOptions,
//           onSelectionChanged: (newList) {
//             setState(() => selectedRelationshipOptions = newList);
//           },
//           showOtherOptions: showOtherRelationship,
//           onToggleChanged: (value) {
//             setState(() => showOtherRelationship = value);
//   },
// ),

//         SizedBox(height: 20),

//         // Additional Filters
//         ExpandableFilter(
//             title: "What Are Their Family Plans?",
//             options: [
//               "Don’t want kids",
//               "Open to kids",
//               "Want kids",
//               "Not sure",
//             ],
//           ),
//            ExpandableFilter(
//             title: "Do They Have Kids?",
//             options: [
//               "Have kids",
//               "Don't have kids"
//             ],
//           ),
//            ExpandableFilter(
//             title: "What\'s Their Religion?",
//             options: [
//              "Agnostic",
//              "Atheist",
//              "Buddhist",
//              "Catholic",
//              "Christian",
//              "Hindu",
//              "Jain",
//              "Jewish",
//              "Mormon",
//              "Latter-day Saint",
//              "Muslim"
//             ],
//           ),
//            ExpandableFilter(
//             title: "'What\'s Their Education Level?",
//             options: [
//               "High school",
//               "Vocational school",
//               "In college",
//               "Undergraduate degree",
//               "In grad school",
//               "Graduate degree"
//             ],
//           ),
//            ExpandableFilter(
//             title: "What Are Their Political Views?",
//             options: [
//               "Apolitical",
//               "Moderate",
//               "Left",
//               "Right",
//               "Communist",
//               "Socialist"
//             ],
//           ),
//            ExpandableFilter(
//             title: "Do They Exercise?",
//             options: [
//               "Active",
//               "Sometimes",
//               "Almost never"
//             ],
//           ),
//         // _buildExpandableFilter('What Are Their Family Plans?'),
//         // _buildExpandableFilter('Do They Have Kids?'),
//         // _buildExpandableFilter('What\'s Their Religion?'),
//         // _buildExpandableFilter('What\'s Their Education Level?'),
//         // _buildExpandableFilter('What Are Their Political Views?'),
//         // _buildExpandableFilter('Do They Exercise?'),
        
//         SizedBox(height: 30),
        
//         // Apply Button
//      Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFF869E23), Color(0xFF000000)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//           borderRadius: BorderRadius.circular(30),
//         ),
//         child: ElevatedButton(
//           onPressed: () {},
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.transparent, // Make button background transparent
//             shadowColor: Colors.transparent,     // Remove elevation shadow
//             padding: EdgeInsets.symmetric(vertical: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           child: Text(
//             'Apply',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w500,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//       ],
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 12),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.w500,
//           color: Colors.grey[800],
//         ),
//       ),
//     );
//   }

// Widget _buildGenderDropdown() {
//   return Container(
//     padding: EdgeInsets.symmetric(horizontal: 16),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(30),
//       border: Border.all(color: Color(0xFF869E23), width: 1),
//     ),
//     child: DropdownButtonFormField<String>(
//       value: gender,
//       decoration: InputDecoration(
//         border: InputBorder.none,
//       ),
//       icon: Icon(Icons.chevron_right, color: Colors.black54),
//       items: ['Women', 'Men', 'Everyone']
//           .map((g) => DropdownMenuItem<String>(
//                 value: g,
//                 child: Text(
//                   g,
//                   style: TextStyle(fontWeight: FontWeight.w400),
//                 ),
//               ))
//           .toList(),
//       onChanged: (value) {
//         setState(() {
//           gender = value!;
//         });
//       },
//     ),
//   );
// }

// Widget _buildAgeRangeSelector() {
//   RangeValues ageRangeValues = RangeValues(18, 27);

//   return StatefulBuilder(
//     builder: (context, setState) {
//       return Container(
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: Color(0xFF869E23), width: 1),
//           borderRadius: BorderRadius.circular(30),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Between ${ageRangeValues.start.round()} And ${ageRangeValues.end.round()}',
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 16,
//               ),
//             ),
//             SizedBox(height: 8),
//             RangeSlider(
//               values: ageRangeValues,
//               min: 18,
//               max: 60,
//               divisions: 42,
//               activeColor: Color(0xFF434F11),
//               inactiveColor: Colors.grey[300],
//               onChanged: (RangeValues values) {
//                 setState(() {
//                   ageRangeValues = values;
//                 });
//               },
//             ),
//             SizedBox(height: 8),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Text(
//                     'See People 2 Years Either Side If I Run Out',
//                     style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Switch(
//                   value: seeYounger,
//                   onChanged: (value) {
//                     setState(() {
//                       seeYounger = value;
//                     });
//                   },
//                   activeColor: Colors.white,
//                   activeTrackColor: Color(0xFF434F11),
//                   inactiveThumbColor: Colors.white,
//                   inactiveTrackColor: Colors.grey[300],
//                 ),
//               ],
//             ),

//           ],
//         ),
//       );
//     },
//   );
// }

// Widget buildDistanceSelector({
//   required double distance,
//   required bool seeDistant,
//   required ValueChanged<double> onSliderChange,
//   required ValueChanged<bool> onToggleChange,
// }) {
//   return Container(
//     padding: EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       border: Border.all(color: Color(0xFF869E23), width: 1),
//       borderRadius: BorderRadius.circular(30),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Up To ${distance.round()} Kilometres Away',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: Colors.grey[700],
//           ),
//         ),
//         Slider(
//           value: distance,
//           min: 10,
//           max: 200,
//           divisions: 19,
//           label: '${distance.round()} km',
//           onChanged: onSliderChange,
//           activeColor: Color(0xFF434F11),
//           inactiveColor: Colors.grey[300],
//         ),
//         SizedBox(height: 8),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Text(
//                 'See People 2 Years\nEither Side If I Run Out',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey[600],
//                 ),
//               ),
//             ),
//             Switch(
//               value: seeDistant,
//               onChanged: onToggleChange,
//               activeColor: Colors.white,
//               activeTrackColor: Color(0xFF434F11),
//               inactiveThumbColor: Colors.white,
//               inactiveTrackColor: Colors.grey[300],
//             ),
//           ],
//         )
//       ],
//     ),
//   );
// }

// /// Interests section styled like the screenshot
// Widget buildInterestsSection({
//   required List<String> interests,
//   required bool showOtherInterests,
//   required ValueChanged<bool> onToggleChanged,
// }) {
//   return Container(
//     width: double.infinity,
//     padding: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       border: Border.all(color: const Color(0xFF869E23)),
//       borderRadius: BorderRadius.circular(20),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // title
//         const Text(
//           'Filter By Your Interest',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//         ),
//         const SizedBox(height: 16),

//         // chips
//         Wrap(
//           spacing: 12,
//           runSpacing: 12,
//           children:
//               interests.map((i) => _buildInterestChip(i)).toList(),
//         ),
//         const SizedBox(height: 24),

//         // helper paragraph
//         const Text(
//           "We'll Try To Show You People Who Share Any One Of The Interest You Select.",
//           style: TextStyle(fontSize: 14, color: Colors.grey),
//         ),

//         // thin olive separator
//         Container(
//           margin: const EdgeInsets.symmetric(vertical: 16),
//           height: 1,
//           color: const Color(0xFF869E23),
//         ),

//         // toggle row
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Expanded(
//               child: Text(
//                 'Show Other People If\nRun Out',
//                 style: TextStyle(fontSize: 14, color: Colors.grey),
//               ),
//             ),
//             Switch(
//               value: showOtherInterests,
//               onChanged: onToggleChanged,
//               activeColor: Colors.white,
//               activeTrackColor: const Color(0xFF434F11), // merged green-black shade
//               inactiveThumbColor: Colors.white,
//               inactiveTrackColor: Colors.grey[300],
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

// Widget buildVerifiedSection({
//   required bool verified,
//   required ValueChanged<bool> onToggleChanged,
//   required VoidCallback onInfoTap,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       // Title + Info link
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text(
//             'Have They Verified \nThemselves?',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           GestureDetector(
//             onTap: onInfoTap,
//             child: const Text(
//               'What Is This?',
//               style: TextStyle(
//                 fontSize: 14,
//                 decoration: TextDecoration.underline,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ],
//       ),
//       const SizedBox(height: 12),

//       // Toggle Row
//       Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           border: Border.all(color: Color(0xFF869E23)),
//           borderRadius: BorderRadius.circular(28),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: const [
//                 Text(
//                   'Verified Only',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 Icon(Icons.verified, color: Color(0xFF869E23), size: 20),
//               ],
//             ),
//             Switch(
//               value: verified,
//               onChanged: onToggleChanged,
//               activeColor: Colors.white,
//               activeTrackColor: const Color(0xFF434F11), // merged green-black shade
//               inactiveThumbColor: Colors.white,
//               inactiveTrackColor: Colors.grey[300],
//             ),
//           ],
//         ),
//       ),
//     ],
//   );
// }



//  Widget _buildSelectionContainer(String text) {
//   return Container(
//     width: double.infinity,
//     padding: EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: Colors.grey[100],
//       borderRadius: BorderRadius.circular(30),
//       border: Border.all(color: Color(0xFF869E23), width: 1),
//     ),
//     child: SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: [
//           Text(
//             text,
//             style: TextStyle(
//               color: text == 'Select Languages' ? Colors.grey[500] : Colors.grey[700],
//               fontSize: 16,
//             ),
//           ),
//           SizedBox(width: 12), // Spacing between text and icon
//           Icon(Icons.chevron_right, color: Colors.grey[400]),
//         ],
//       ),
//     ),
//   );
// }

// //  advanced filter
// Widget buildHeightSelector({
//   required RangeValues heightRange,
//   required bool showOtherHeight,
//   required ValueChanged<RangeValues> onRangeChanged,
//   required ValueChanged<bool> onToggleChanged,
// }) {
//   bool isFullRange = heightRange.start == 140 && heightRange.end == 200;

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       const Text(
//         'How Tall Are They?',
//         style: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//       const SizedBox(height: 8),
//       Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           border: Border.all(color: Color(0xFF869E23)),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Range label
//             Text(
//               isFullRange
//                   ? 'Any Height Is Just Fine'
//                   : '${heightRange.start.round()} cm - ${heightRange.end.round()} cm',
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),

//             // Range slider
//             RangeSlider(
//               values: heightRange,
//               min: 140,
//               max: 200,
//               // divisions: 12,
//               labels: RangeLabels(
//                 '${heightRange.start.round()}',
//                 '${heightRange.end.round()}',
//               ),
//               onChanged: onRangeChanged,
//               activeColor: Color(0xFF434F11),
//               inactiveColor: Colors.grey[300],
//             ),
//             const SizedBox(height: 8),

//             // Toggle
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Show Other People If I\nRun Out',
//                   style: TextStyle(fontSize: 14, color: Colors.grey),
//                 ),
//                 Switch(
//                   value: showOtherHeight,
//                   onChanged: onToggleChanged,
//                   activeColor: Colors.white,
//                   activeTrackColor: Color(0xFF434F11),
//                   inactiveThumbColor: Colors.white,
//                   inactiveTrackColor: Colors.grey[300],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ],
//   );
// }

// Widget buildRelationshipSelector({
//   required List<String> selectedOptions,
//   required ValueChanged<List<String>> onSelectionChanged,
//   required bool showOtherOptions,
//   required ValueChanged<bool> onToggleChanged,
// }) {
//   final List<String> options = [
//     'A Long - Term Relationship',
//     'Fun, Casual Dates',
//     'Marriage',
//     'Intimacy, Without Commitment',
//     'A Life Partner',
//     'Ethical Non-Monogamy',
//   ];

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       const Text(
//         'What Are They Looking For?',
//         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//       ),
//       const SizedBox(height: 8),

//       Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//         decoration: BoxDecoration(
//           border: Border.all(color: Color(0xFF869E23)),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           children: [
//             ...options.map((option) {
//               bool isSelected = selectedOptions.contains(option);
//               return Column(
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       List<String> updatedList = List.from(selectedOptions);
//                       if (isSelected) {
//                         updatedList.remove(option);
//                       } else {
//                         updatedList.add(option);
//                       }
//                       onSelectionChanged(updatedList);
//                     },
//                     child: Row(
//                       children: [
//                         Checkbox(
//                           value: isSelected,
//                           onChanged: (_) {
//                             List<String> updatedList = List.from(selectedOptions);
//                             if (isSelected) {
//                               updatedList.remove(option);
//                             } else {
//                               updatedList.add(option);
//                             }
//                             onSelectionChanged(updatedList);
//                           },
//                           activeColor: Color(0xFF434F11),
//                         ),
//                         Expanded(
//                           child: Text(
//                             option,
//                             style: const TextStyle(fontSize: 15),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   if (option != options.last)
//                     const Divider(
//                       color: Color(0xFF869E23),
//                       thickness: 1,
//                       height: 0,
//                     ),
//                 ],
//               );
//             }).toList(),

//             const SizedBox(height: 12),

//             // Toggle
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Show Other People If I\nRun Out',
//                   style: TextStyle(fontSize: 14, color: Colors.grey),
//                 ),
//                 Switch(
//                   value: showOtherOptions,
//                   onChanged: onToggleChanged,
//                   activeColor: Colors.white,
//                   activeTrackColor: Color(0xFF434F11),
//                   inactiveThumbColor: Colors.white,
//                   inactiveTrackColor: Colors.grey[300],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ],
//   );
// }



//   Widget _buildToggleRow(String text, bool value, Function(bool) onChanged) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Expanded(
//           child: Text(
//             text,
//             style: TextStyle(color: Colors.grey[600], fontSize: 14),
//           ),
//         ),
//         GestureDetector(
//           onTap: () => onChanged(!value),
//           child: Container(
//             width: 48,
//             height: 24,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: value ? Colors.green[500] : Colors.grey[300],
//             ),
//             child: AnimatedAlign(
//               duration: Duration(milliseconds: 200),
//               alignment: value ? Alignment.centerRight : Alignment.centerLeft,
//               child: Container(
//                 width: 20,
//                 height: 20,
//                 margin: EdgeInsets.all(2),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//  Widget _buildInterestChip(String label) {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//     decoration: BoxDecoration(
//       color: const Color(0xFFE9F1C4),                   // light olive fill
//       border: Border.all(color: const Color(0xFF869E23)),
//       borderRadius: BorderRadius.circular(28),
//     ),
//     child: Text(
//       '$label +',
//       style: const TextStyle(
//         fontSize: 14,
//         fontWeight: FontWeight.w600,
//         color: Color(0xFF4D5A12),                       // darker olive text
//       ),
//     ),
//   );
// }

//   Widget _buildRelationshipOptions() {
//     List<String> options = [
//       'A Long - Term Relationship',
//       'Fun, Casual Dates',
//       'Marriage',
//       'Intimacy, Without Commitment',
//       'A Life Partner',
//       'Ethical Non-Monogamy',
//     ];

//     return Column(
//       children: options.map((option) {
//         return RadioListTile<String>(
//           title: Text(option),
//           value: option,
//           groupValue: relationshipType,
//           onChanged: (String? value) {
//             setState(() {
//               relationshipType = value!;
//             });
//           },
//           activeColor: Colors.green[600],
//           contentPadding: EdgeInsets.zero,
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildExpandableFilter(String title) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.grey[50],
//               borderRadius: BorderRadius.circular(8),
//             ),
            
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//                 Icon(Icons.add, color: Colors.green[600]),
//               ],
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Add This Filter',
//             style: TextStyle(
//               color: Colors.grey[600],
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ExpandableFilter extends StatefulWidget {
//   final String title;
//   final List<String> options;

//   const ExpandableFilter({
//     required this.title,
//     required this.options,
//     super.key,
//   });

//   @override
//   State<ExpandableFilter> createState() => _ExpandableFilterState();
// }

// class _ExpandableFilterState extends State<ExpandableFilter> {
//   bool isExpanded = false;
//   bool showOthers = false;
//   Set<String> selectedOptions = {};

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         /// SECTION TITLE (outside the box)
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
//           child: Text(
//             widget.title,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//         ),

//         /// TAPPABLE FILTER CARD
//         GestureDetector(
//           onTap: () => setState(() => isExpanded = !isExpanded),
//           child: Container(
//             margin: const EdgeInsets.symmetric(vertical: 4),
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//             decoration: BoxDecoration(
//               color: Colors.grey[50],
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: Colors.green.shade400),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: const [
//                 Text(
//                   'Add This Filter',
//                   style: TextStyle(
//                     fontSize: 15,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Icon(Icons.add, color: Colors.green),
//               ],
//             ),
//           ),
//         ),

//         /// EXPANDED CONTENT
//         if (isExpanded)
//           Container(
//             margin: const EdgeInsets.only(bottom: 10),
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Column(
//               children: [
//                 const Divider(),
//                 ...widget.options.map((option) => CheckboxListTile(
//                       value: selectedOptions.contains(option),
//                       title: Text(option),
//                       controlAffinity: ListTileControlAffinity.leading,
//                       onChanged: (checked) {
//                         setState(() {
//                           if (checked == true) {
//                             selectedOptions.add(option);
//                           } else {
//                             selectedOptions.remove(option);
//                           }
//                         });
//                       },
//                     )),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Show other people if I run out",
//                       style: TextStyle(color: Colors.grey[600]),
//                     ),
//                     Switch(
//                       value: showOthers,
//                       onChanged: (val) => setState(() => showOthers = val),
//                       activeColor: Colors.white,
//                       activeTrackColor: Color(0xFF434F11),
//                       inactiveThumbColor: Colors.white,
//                       inactiveTrackColor: Colors.grey[300],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }
// }

