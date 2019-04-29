import Foundation
import RxCocoa
import RxSwift

protocol SampleViewModeling {
    var inputs: SampleViewModelInputs { get }
    var outputs: SampleViewModelOutputs { get }
    var coordinatorOutputs: SampleViewModelCoordinatorOutputs { get }
}

protocol SampleViewModelInputs {
    var viewWillAppear: PublishRelay<Void> { get }
    var okButtonDidTap: PublishRelay<Void> { get }
}

protocol SampleViewModelOutputs {
    var isOkButtonEnabled: Driver<Bool> { get }
    var showError: Signal<Sample.Error> { get }
}

protocol SampleViewModelCoordinatorOutputs {
    var show: Signal<SampleViewModel.RequestScreen> { get }
}

enum Test {
    case typo
    case sample
    case hello
    case hellow
}

// test text sampl
// misspell
final class SampleViewModel: SampleViewModelInputs, SampleViewModelOutputs, SampleViewModelCoordinatorOutputs, SampleViewModeling {

    var inputs: SampleViewModelInputs { return self }
    var outputs: SampleViewModelOutputs { return self }
    var coordinatorOutputs: SampleViewModelCoordinatorOutputs { return self }

    // MARK: - SampleViewModelInputs
    let viewWillAppear: PublishRelay<Void> = PublishRelay()
    let okButtonDidTap: PublishRelay<Void> = PublishRelay()

    // MARK: - SampleViewModelOutputs
    let isOkButtonEnabled: Driver<Bool>
    let showErrorr: Signal<Sample.Error>

    // MARK: - SampleViewModelCoordinatorOutputs
    let show: Observable<RequestScreen>
    
    // MARK: -
    
    // ...
}
