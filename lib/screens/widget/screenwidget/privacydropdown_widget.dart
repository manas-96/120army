import '../../../exports.dart';
import '../../../global.dart';
import '../../../shared_pref.dart';
import '../../../statemanagment/locationtagfriends/locationtagfriends_bloc.dart';

class PrivacyDropdown extends StatefulWidget {
  const PrivacyDropdown({super.key});

  @override
  State<PrivacyDropdown> createState() => _PrivacyDropdownState();
}

class _PrivacyDropdownState extends State<PrivacyDropdown> {
  final List<Map<String, dynamic>> dropdownItems = const [
    {'label': 'Public', 'icon': Icons.public},
    {'label': 'Friends', 'icon': Icons.group},
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialPrivacy();
  }

  Future<void> _loadInitialPrivacy() async {
    // Read is_official value from SharedPreferences
    String? isOfficial = await SharedPrefUtils.readPrefStr("is_official");

    String privacyFromPref;
    if (isOfficial == "1") {
      privacyFromPref = "Public";
    } else if (isOfficial == "0") {
      privacyFromPref = "Friends";
    } else {
      privacyFromPref = "Friends"; // fallback
    }

    // Update Bloc so state.privacy is correct initially
    // ignore: use_build_context_synchronously
    context.read<LocationtagfriendsBloc>().add(UpdatePrivacy(privacyFromPref));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationtagfriendsBloc, LocationtagfriendsState>(
      builder: (context, state) {
        if (state is LocationtagfriendsLoaded) {
          return IgnorePointer(
            ignoring: true, // if you want read-only, remove to allow edit
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: kLightPrimaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                icon: const SizedBox.shrink(),
                menuWidth: 115,
                value: state.privacy, // always use Bloc state
                isDense: true,
                isExpanded: false,
                dropdownColor: Colors.white,
                underline: const SizedBox(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    context.read<LocationtagfriendsBloc>().add(
                      UpdatePrivacy(newValue),
                    );
                  }
                },
                items:
                    dropdownItems.map((item) {
                      return DropdownMenuItem<String>(
                        value: item['label'],
                        child: Row(
                          children: [
                            Icon(
                              item['icon'],
                              size: titlesize,
                              color: kPrimaryColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              item['label'],
                              style: TextStyle(fontSize: formLabelFontSize),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
