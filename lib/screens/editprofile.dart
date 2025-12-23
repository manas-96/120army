import '../exports.dart';
import '../global.dart';
import '../shimmerloader/edit_profile_loader.dart';
import '../statemanagment/profile/profile_bloc.dart';
import '../statemanagment/profiledatashare/profiledatashare_bloc.dart';
import 'widget/screenwidget/editprofile_widget.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  @override
  void initState() {
    super.initState();
    // context.read<ProfileBloc>().add(ProfileLoadedEvent());
  }

  Future<void> _handleRefresh() async {
    context.read<ProfileBloc>().add(ProfileLoadedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfiledatashareBloc, ProfiledatashareState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            iconTheme: IconThemeData(color: Colors.white),
            centerTitle: true,
            title: Text(
              "Edit profile",
              style: TextStyle(fontSize: appbarTitle, color: Colors.white),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: BlocConsumer<ProfileBloc, ProfileState>(
                  listener: (context, state) {
                    if (state is ProfileLoaded) {
                      context.read<ProfiledatashareBloc>().add(
                        ProfiledatashareEventLoaded(state.model.data),
                      );
                    }
                  },
                  builder: (context, state) {
                    return BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, state) {
                        if (state is ProfileLoading) {
                          return Editprofileloader();
                        } else if (state is ProfileError) {
                          return Text(state.error);
                        } else if (state is ProfileLoaded) {
                          if (state.model.status == "success") {
                            return Editprofilewidget();
                          } else {
                            return Text(state.model.msg);
                          }
                        } else {
                          return Text("Something went wrong");
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
