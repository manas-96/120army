import '../../exports.dart';
import '../../global.dart';
import '../../model/photoslist_model.dart';
import '../../statemanagment/photolist/photolist_bloc.dart';
import '../widget/cached_image.dart';

class OtherPhotoswidgets extends StatefulWidget {
  const OtherPhotoswidgets({super.key});

  @override
  State<OtherPhotoswidgets> createState() => _OtherPhotoswidgetsState();
}

class _OtherPhotoswidgetsState extends State<OtherPhotoswidgets> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotolistBloc, PhotolistState>(
      builder: (context, state) {
        if (state is PhotolistLoading) {
          return SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            ),
          );
        } else if (state is PhotolistLoaded) {
          List<PhotolistDatum>? data = state.model.data;
          return MasonryGridView.count(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(kDefaultPadding),
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            shrinkWrap: true,
            itemCount: data!.length,
            itemBuilder: (context, index) {
              return data[index].fileType == "image"
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: MyImageWidget(
                      imageUrl: data[index].fileUrls!,
                      radius: false,
                      radiusVal: 0,
                    ),
                  )
                  : SizedBox.shrink();
            },
          );
        } else if (state is PhotolistError) {
          return Center(child: Text(state.error));
        } else {
          return Center(child: Text('Something went wrong'));
        }
      },
    );
  }
}
