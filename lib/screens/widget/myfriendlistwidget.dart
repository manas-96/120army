import '../../exports.dart';
import '../../global.dart';
import '../../model/suggest_friend_list_model.dart';
import 'cached_image.dart';

class Myfriendlist extends StatelessWidget {
  const Myfriendlist({super.key, required this.data, this.fullscreen = false});

  final List<Suggestdatum> data;
  final bool fullscreen;

  @override
  Widget build(BuildContext context) {
    final content = GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 115,
      ),
      shrinkWrap: true,
      itemCount: fullscreen ? data.length : (data.length > 3 ? 3 : data.length),
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              "/otherprofile",
              arguments: {'userID': data[index].id.toString()},
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              data[index].profileImage != ""
                  ? MyImageWidget(
                    imageUrl: data[index].profileImage,
                    profilePic: true,
                    width: double.infinity,
                    height: 75,
                  )
                  : Container(
                    height: 75,
                    padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: noimageBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset(
                      "assets/images/user.png",
                      fit: BoxFit.cover,
                    ),
                  ),
              Text(
                "${data[index].firstName} ${data[index].lastName}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );

    if (fullscreen) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text(
            "Friend List",
            style: TextStyle(fontSize: appbarTitle, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: content,
        ),
      );
    }

    return content;
  }
}
