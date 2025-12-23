import 'exports.dart';
import 'global.dart';
import 'routes/routes.dart';
import 'services/local_notification_service.dart';
import 'services/main_service.dart';
import 'services/push_notification_handlar.dart';
import 'shared_pref.dart';
import 'statemanagment/challenges/challenges_bloc.dart';
import 'statemanagment/commentlist/commentlist_bloc.dart';
import 'statemanagment/friendlist/friendlist_bloc.dart';
import 'statemanagment/friendrequestlist/friendrequestlist_bloc.dart';
import 'statemanagment/homewalllist/homewalllist_bloc.dart';
import 'statemanagment/locationtagfriends/locationtagfriends_bloc.dart';
import 'statemanagment/otherprofile/otherprofile_bloc.dart';
import 'statemanagment/photolist/photolist_bloc.dart';
import 'statemanagment/profile/profile_bloc.dart';
import 'statemanagment/profiledatashare/profiledatashare_bloc.dart';
import 'statemanagment/profillecoverchange/profillecoverchange_bloc.dart';
import 'statemanagment/rewardlist/rewardlist_bloc.dart';
import 'statemanagment/rewardslevel/rewardslevel_bloc.dart';
import 'statemanagment/searchfriendlist/searchfriendlist_bloc.dart';
import 'statemanagment/signupdatatransfer/signup_bloc.dart';
import 'statemanagment/suggestfriendlist/suggestfriendlist_bloc.dart';
import 'statemanagment/weeklypc/weeklypc_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await NotificationHandler.init();

  await NotificationService.init();
  String? loginStatus = await SharedPrefUtils.readPrefStr("accessToken");
  String initialRoute = (loginStatus != null) ? '/splash' : '/login';
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await Hive.openBox('alarmBox');
  MainService().ensureStaticAlarmExists();
  await SharedPrefUtils.preload();
  // Start global Pusher event listener

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialRoute});
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SignupBloc()),
          BlocProvider(
            create: (context) => ProfileBloc()..add(ProfileLoadedEvent()),
          ),
          BlocProvider(create: (context) => ProfiledatashareBloc()),
          // BlocProvider(
          //   create: (context) => RewardlistBloc()..add(RewardlistEventLoaded()),
          // ),
          BlocProvider(create: (context) => RewardlistBloc()),
          BlocProvider(
            create:
                (context) =>
                    RewardslevelBloc()..add(RewardslevelEventTrigger()),
          ),
          BlocProvider(create: (context) => WeeklypcBloc()),
          BlocProvider(create: (context) => ChallengesBloc()),
          BlocProvider(create: (context) => SuggestfriendlistBloc()),
          BlocProvider(create: (context) => FriendrequestlistBloc()),
          BlocProvider(create: (context) => SearchfriendlistBloc()),
          BlocProvider(create: (context) => FriendlistBloc()),
          BlocProvider(create: (context) => LocationtagfriendsBloc()),
          BlocProvider(create: (context) => HomewalllistBloc()),
          BlocProvider(create: (context) => ProfillecoverchangeBloc()),
          BlocProvider(create: (context) => OtherprofileBloc()),
          BlocProvider(create: (context) => PhotolistBloc()),
          BlocProvider(create: (context) => CommentlistBloc()),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          initialRoute: initialRoute,
          onGenerateRoute: RouteGenerator.generateRoute,
          debugShowCheckedModeBanner: false,
          title: '120 ARMY PRAYER',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: kPrimaryColor,
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: Colors.white,
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme.apply(bodyColor: Colors.black),
            ).copyWith(
              displayLarge: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
              displayMedium: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              displaySmall: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),

              headlineSmall: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              bodyMedium: GoogleFonts.poppins(fontSize: 14),
              bodySmall: GoogleFonts.poppins(fontSize: 12),
            ),
          ),
          builder: (context, child) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                final currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              child: MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(1.0)),
                child: child!,
              ),
            );
          },
          // builder: (context, child) {
          //   return Padding(
          //     padding: EdgeInsets.only(
          //       bottom: MediaQuery.of(context).viewPadding.bottom,
          //     ),
          //     child: child,
          //   );
          // },
        ),
      ),
    );
  }
}



// https://staging.api.120connect.com/api//app/login

// user4@mailinator.com
// Qwerty@1234