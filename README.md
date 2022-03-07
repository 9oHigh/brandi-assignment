# Brandi

### Commit Convention
- Add : 파일 추가
- Remove : 파일 삭제
- Feat : 새로운 기능 추가
- Design : UI 변경사항이 있는 경우
- Fix : 버그를 수정한 경우
- Refactor : 코드 리팩토링
- 작성 내용 : 파일 / 변경사항

### Architecture
  * MVVM
    * 의존성 : View -> ViewModel -> Service -> Model -> Repository -> Entity
    * Repository

      ![repository](https://user-images.githubusercontent.com/53691249/156909068-b018a325-fe58-4629-bad0-096dd8b5c9e2.png)
      * Moya를 이용하여 API 통신 
      
      ```swift

      import Moya

      final class SearchRepository {

          private let provider = MoyaProvider<SearchTarget>()

          func fetchSources(apiKey: String, parm : SearchParameter, onCompletion: @escaping (Source?,APIError?) -> Void){

              provider.request(.requestSource(apiKey: apiKey, parm: parm)){ result in
                  switch result {
                  case .success(let response):
                      onCompletion(try? response.map(Source.self), nil)
                  case .failure(let error):
                      let apiError = APIError(rawValue: error.response?.statusCode ?? 0)
                      onCompletion(nil,apiError)
                  }
              }
          }
      }
      ```
        
      * Entity로 Decoding, 전달

    * Service
      
      ![service](https://user-images.githubusercontent.com/53691249/156909286-00c49f31-7584-4a70-ad2d-f1cec78099ca.png)
      * 전달받은 Entity -> ImageModel
       ```swift
       final class Service {
    
          private let apiKey = ""
          private let repository = SearchRepository()
          private var model = ImageModel(meta: nil, documents: nil)

          func fetchDatas(parm: SearchParameter, onCompletion: @escaping (ImageModel?,APIError?) -> Void){
               repository.fetchSources(apiKey: apiKey, parm: parm) { [weak self] source, error in

               guard let source = source else {
                    onCompletion(nil,error)
                    return
                }
                self?.model.meta = source.meta
                self?.model.documents = source.documents
                onCompletion(self?.model,nil)
              }
          }
      }
      ```
### Trouble Shooting

  1. 검색: 검색 이후 스크롤시 재검색이 되어 CollectionView의 setContentOffset이 한번 더 적용되는 이슈
      * 해결방법
        * 기존의 query와 같은 query가 들어오게 된다면 함수를 실행하지 않고 바로 리턴

          ```swift
          func fetchImages(query: String, onCompletion: @escaping (ImageModel?) -> Void){
            // overlap return
            if query == overlap { return }
            else { overlap = query }

            '''
           }
          ```
  2. Indicator: 마지막 페이지 하단에서도 나타나는 이슈

      * 첫 번째 조건: 다음 이미지 검색 가이드를 보면 최대 Page는 50이므로 이를 기준

         ![page](https://user-images.githubusercontent.com/53691249/156909733-e2508b53-60bc-4f78-8e67-79ca780ec200.png)

      * 두 번째 조건: Meta.isEnd의 값을 기준

         ![idend](https://user-images.githubusercontent.com/53691249/156909813-cf180335-13f8-4295-94d1-a5edd9deaaf5.png)
     
      * isContinue 프로퍼티를 ViewModel에서 초기화 및 사용, 넘겨준 값을 이용해 indicator start/stop
       ```swift
       func addImages(onCompletion: @escaping (ImageModel?,Bool?)->Void){

              '''

              var isContinue : Bool
              self?.items.meta.isEnd == false ? (self?.page += 1) : ()
              // Max page
              isContinue = self?.page == 50 ? false : true
              // Or isLast
              isContinue = self!.items.meta.isEnd ? true : false
              onCompletion(self?.items,isContinue)
       }
       ```

### 고려사항
 * UI/UX: Indicator를 CollectionView Footer에 적용
 * Network: 와이파이, 셀룰러 연결 상태를 확인하고 연결되어 있지 않다면 ToastMessage
 * 이모티콘: 이모티콘을 입력시에 serverError가 발생 -> 검색결과 없음 화면으로 대체

### 해결하지 못한 것
  * 스크롤의 속도가 너무 빠르면 데이터를 추가로 가지고 오지 못하고 Indicator만 돌아가는 이슈
  * API Error가 발생했음에도 .success로 결과가 분리되는 이슈
    * success의 statusCode를 통해 APIError 초기화 및 사용 ( ViewModel에서 분기처리 )

      ```swift
      case .success(let response):
          let apiError = APIError(rawValue: response.statusCode)
          onCompletion(try? response.map(Source.self),apiError)
      ```



