## 项目 4：BetterRest

使用机器学习改善睡眠

## 概述

#### [BetterRest：简介]

这个 SwiftUI 项目是另一个基于表单的应用程序，它会要求用户输入信息并将所有信息转换为警报，这听起来可能很枯燥——你已经这样做了，对吧？

嗯，是的，但练习从来都不是坏事。然而，我们之所以有一个相当简单的项目，是因为我想向您介绍 iOS 开发的真正强大功能之一：机器学习 (ML)。

所有 iPhone 都内置了一种称为 Core ML 的技术，它允许我们编写代码，根据之前看到的数据对新数据进行预测。我们将从一些原始数据开始，将其作为训练数据提供给我们的 Mac，然后使用结果构建一个能够对新数据进行准确估计的应用程序——所有这些都在设备上进行，并为用户提供完全的隐私。

我们正在构建的实际应用程序称为 BetterRest，它旨在通过向喝咖啡者提出三个问题来帮助他们睡个好觉：

1. 他们想什么时候醒来？
2. 他们想要大约多少小时的睡眠时间？
3. 他们每天喝多少杯咖啡？

一旦我们有了这三个值，我们会将它们输入 Core ML 以获得一个结果，告诉我们他们应该什么时候睡觉。如果你仔细想想，有数十亿种可能的答案——所有不同的醒来时间乘以所有睡眠时间，再乘以全部咖啡量。

这就是机器学习的用武之地：使用一种称为***回归分析***的技术，我们可以要求计算机提出一种能够代表我们所有数据的算法。这反过来又允许它将算法应用于它以前从未见过的新数据，并获得准确的结果。

您将需要为此项目下载一些文件，您可以从 GitHub 下载：[https](https://github.com/twostraws/HackingWithSwift) : [//github.com/twostraws/HackingWithSwift](https://github.com/twostraws/HackingWithSwift) - 确保查看文件的 SwiftUI 部分。

一旦你有了这些，继续在 Xcode 中创建一个名为 BetterRest 的新 App 项目，确保以 iOS 15 或更高版本为目标。和之前一样，我们将从概述构建应用程序所需的各种技术开始，所以让我们开始吧……



#### [使用 Stepper 输入数字]

SwiftUI 有两种让用户输入数字的方法，我们将在这里使用的一种是`Stepper`：一个简单的 - 和 + 按钮，可以点击它来选择一个精确的数字。另一个选项是`Slider`，我们稍后将使用它——它还允许我们从一系列值中进行选择，但不太精确。

步进电机是足够聪明，将工作与任何类型的号码类型你喜欢的，所以你可以绑定他们`Int`，`Double`和更多的，它会自动适应。例如，我们可能会创建这样的属性：

```swift
@State private var sleepAmount = 8.0
```

然后我们可以将它绑定到一个步进器，以便它显示当前值，如下所示：

```swift
Stepper("\(sleepAmount) hours", value: $sleepAmount)
```

当该代码运行时，您将看到 8.000000 小时，您可以点击 - 和 + 以向下步进到 7、6、5 和负数，或向上步进到 9、10、11 等。

默认情况下，步进器仅受其存储范围的限制。我们`Double`在这个例子中使用了 a ，这意味着滑块的最大值绝对是巨大的。

现在，作为两个孩子的父亲，我无法告诉你我有多爱睡觉，但即使是*我*也睡不着。幸运的是，`Stepper`让我们通过提供一个`in`范围来限制我们想要接受的值，如下所示：

```swift
Stepper("\(sleepAmount) hours", value: $sleepAmount, in: 4...12)
```

通过该更改，步进器将从 8 开始，然后允许用户在 4 到 12 之间移动，但不能超过。这使我们可以控制睡眠范围，使用户不能尝试睡 24 小时，但它也可以让我们拒绝不可能的值——例如，你不能睡 -1 小时。

有第四个有用的参数`Stepper`，它是一个`step`值 - 每次移动该值的距离 - 或 + 被点击。同样，这可以是任何类型的数字，但它确实需要匹配用于绑定的类型。因此，如果您绑定到一个整数，则不能使用 a`Double`作为步长值。

在这种情况下，我们可以说用户可以选择 4 到 12 之间的任何睡眠值，以 15 分钟为增量移动：

```swift
Stepper("\(sleepAmount) hours", value: $sleepAmount, in: 4...12, step: 0.25)
```

这开始看起来很有用——我们有一个精确的合理值范围，一个合理的步长增量，用户可以准确地看到他们每次选择的内容。

不过，在我们继续之前，让我们修正一下那个文本：它现在说 8.000000，这是准确的，但有点*太*准确了。为了解决这个问题，我们可以让 Swift 格式化`Double`using `formatted()`：

```swift
Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
```

完美的！

#### [使用 DatePicker 选择日期和时间]

SwiftUI 为我们提供了一个专用的选择器类型，称为`DatePicker`可以绑定到日期属性。是的，Swift 有一个专门用于处理日期的类型，它被称为 - 不出所料 - `Date`。

因此，要使用它，您将从以下`@State`属性开始：

```swift
@State private var wakeUp = Date.now
```

然后，您可以将其绑定到这样的日期选择器：

```swift
DatePicker("Please enter a date", selection: $wakeUp)
```

尝试在模拟器中运行它，这样您就可以看到它的外观。您应该会看到一个可点击的选项来控制日期和时间，以及左侧的“请输入日期”标签。

现在，您可能认为该标签看起来很难看，并尝试将其替换为：

```swift
DatePicker("", selection: $wakeUp)
```

但是如果你这样做，你现在有*两个*问题：日期选择器仍然为标签腾出空间，即使它是空的，现在屏幕阅读器处于活动状态的用户（我们更熟悉的是 VoiceOver）将不知道日期是什么选择器是为了。

更好的选择是使用`labelsHidden()`修饰符，如下所示：

```swift
DatePicker("Please enter a date", selection: $wakeUp)
    .labelsHidden()
```

这仍然包括原始标签，因此屏幕阅读器可以将其用于 VoiceOver，但现在它们在屏幕上不再可见 - 日期选择器不会被一些空文本推到一侧。

日期选择器为我们提供了几个配置选项来控制它们的工作方式。首先，我们可以`displayedComponents`用来决定用户应该看到什么样的选项：

- 如果您不提供此参数，用户会看到天、小时和分钟。
- 如果您使用`.date`用户，请查看月、日和年。
- 如果您使用`.hourAndMinute`用户，则只能看到小时和分钟部分。

所以，我们可以像这样选择一个精确的时间：

```swift
DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
```

最后，还有一个`in`参数与`Stepper`: 我们可以为它提供一个日期范围，日期选择器将确保用户无法选择超出它的范围。

现在，我们使用范围已经有一段时间了，你已经习惯了像`1...5`or 之类的东西`0..<10`，但我们也可以将 Swift 日期与范围一起使用。例如：

```swift
func exampleDates() {
    // create a second Date instance set to one day in seconds from now
    let tomorrow = Date.now.addingTimeInterval(86400)

    // create a range from those two
    let range = Date.now...tomorrow
}
```

这与真正有用的`DatePicker`，但有一些甚至更好：斯威夫特让我们形成*片面的范围*-范围，我们指定的开始或结束，但不同时，留下斯威夫特推断对方。

例如，我们可以像这样创建一个日期选择器：

```swift
DatePicker("Please enter a date", selection: $wakeUp, in: Date.now...)
```

这将允许未来的所有日期，但没有过去的日期 - 将其读作“从当前日期到任何日期”。



#### [使用日期]

让用户输入日期就像`@State`将类型的属性绑定`Date`到`DatePicker`SwiftUI 控件一样简单，但之后事情变得有点复杂。

你看，处理日期很难。就像，*真的*很难——比你想象的要难。比*我*想象的要困难得多，而且我多年来一直在处理日期。

看看这个简单的例子：

```swift
let now = Date.now
let tomorrow = Date.now.addingTimeInterval(86400)
let range = now...tomorrow
```

这将创建从现在到明天同一时间的范围（86400 是一天中的秒数）。

这似乎很容易，但所有的日子都有 86,400 秒吗？如果他们这样做，很多人会失业！想想夏令时：有时时钟向前走（少一小时），有时向后走（多一小时），这意味着在那些日子里我们可能有 23 或 25 小时。然后是闰秒：添加到时钟中以适应地球缓慢旋转的时间。

如果您认为这很难，请尝试从您的 Mac 终端运行它：`cal`. 这将打印当月的简单日历，显示一周中的日期。现在尝试运行`cal 9 1752`，它会显示 1752 年 9 月的日历 - 您会注意到缺少 12 天，这要归功于日历从儒略历移动到公历。

现在，我说这一切的原因并不是要吓跑你——毕竟，约会在我们的节目中是不可避免的。相反，我希望你明白，对于任何重要的事情——任何在我们的代码中真正重要的日期的使用——我们都应该依赖 Apple 的计算和格式化框架。

在我们正在制作的项目中，我们将以三种方式使用日期：

1. 选择一个合理的默认“唤醒”时间。
2. 阅读他们想要醒来的小时和分钟。
3. 以整齐的格式显示他们建议的就寝时间。

如果我们愿意，我们可以手动完成所有这些操作，但是您将进入夏令时、闰秒和公历的领域。

更好的是让 iOS 为我们完成所有艰苦的工作：工作量少得多，而且无论用户的区域设置如何，都可以保证正确。

让我们分别解决每一个问题，从选择一个合理的起床时间开始。

如您所见，Swift 为我们`Date`提供了日期处理功能，它封装了年、月、日、小时、分钟、秒、时区等。但是，我们不想考虑大部分内容——我们想说“给我一个早上 8 点的起床时间，不管今天是什么日子。”

为此，Swift 有一个稍微不同的类型，称为`DateComponents`，它允许我们读取或写入日期的特定部分而不是整个内容。

因此，如果我们想要一个代表今天上午 8 点的日期，我们可以编写如下代码：

```swift
var components = DateComponents()
components.hour = 8
components.minute = 0
let date = Calendar.current.date(from: components)
```

现在，由于日期验证的困难，该`date(from:)`方法实际上返回一个可选的日期，所以最好使用 nil 合并来表示“如果失败，只需将当前日期还给我”，如下所示：

```swift
let date = Calendar.current.date(from: components) ?? Date.now
```

第二个挑战是我们如何读取他们想要醒来的时间。请记住，`DatePicker`它必然会`Date`给我们提供大量信息，因此我们需要找到一种方法来提取仅小时和分钟的组件。

再次，`DateComponents`来救援：我们可以要求 iOS 从某个日期提供特定组件，然后将它们读回。一个小问题是，我们*请求*的值与我们*获得*的值之间存在脱节，这*要*归功于`DateComponents`工作方式：我们可以要求小时和分钟，但我们会收到一个`DateComponents`实例，其所有属性的值都是可选的。是的，我们知道小时和分钟会在那里，因为那些是我们要求的，但我们仍然需要解开选项或提供默认值。

所以，我们可能会写出这样的代码：

```swift
let components = Calendar.current.dateComponents([.hour, .minute], from: someDate)
let hour = components.hour ?? 0
let minute = components.minute ?? 0
```

最后一个挑战是我们如何格式化日期和时间，这里我们有两个选择。

首先是依赖`format`过去对我们非常有效的参数，在这里我们可以询问我们想要显示的日期的任何部分。

例如，如果我们只想要某个日期的时间，我们可以这样写：

```swift
Text(Date.now, format: .dateTime.hour().minute())
```

或者如果我们想要日、月和年，我们可以这样写：

```swift
Text(Date.now, format: .dateTime.day().month().year())
```

您可能想知道它如何适应处理不同的日期格式——例如，在英国，我们使用日/月/年，但在其他一些国家，他们使用月/日/年。好吧，神奇的是我们不需要担心这一点：当我们编写时，`day().month().year()`我们*要求*的是数据，而不是*排列*它，iOS 会使用用户的偏好自动格式化数据。

作为替代方案，我们可以`formatted()`直接在日期上使用该方法，传入配置选项来设置日期和时间的格式，如下所示：

```swift
Text(Date.now.formatted(date: .long, time: .shortened))
```

问题的关键是，日期*是*辛苦，但苹果已经为我们提供帮助者的堆栈，使他们*少*辛苦。如果您学会很好地使用它们，您将编写更少的代码，并编写更好的代码！



#### [使用 Create ML 训练模型]

在 iOS 11 中，设备端机器学习从“极难实现”变为“非常有可能，而且非常强大”，这一切都归功于一个 Apple 框架：Core ML。一年后，Apple 推出了名为 Create ML 的第二个框架，将“易于操作”添加到列表中，然后第二年，Apple 推出了一个 Create ML 应用程序，该应用程序使整个过程拖放。由于所有这些工作，现在任何人都可以将机器学习添加到他们的应用程序中。

Core ML 能够处理各种训练任务，例如识别图像、声音甚至运动，但在本例中，我们将研究表格回归。这是一个花哨的名字，在机器学习中很常见，但它真正的意思是我们可以在 Create ML 中抛出大量类似电子表格的数据，并要求它找出各种值之间的关系。

机器学习分两步完成：我们训练模型，然后让模型进行预测。训练是计算机查看我们所有数据以找出我们拥有的所有值之间的关系的过程，在大型数据集中，它可能需要很长时间——很容易是几个小时，甚至可能更长。预测是在设备上完成的：我们将训练好的模型提供给它，它会使用以前的结果来对新数据进行估计。

现在让我们开始训练过程：请在您的 Mac 上打开 Create ML 应用程序。如果您不知道它在哪里，您可以从 Xcode 中启动它，方法是转到 Xcode 菜单并选择 Open Developer Tool > Create ML。

Create ML 应用程序要做的第一件事是要求您创建一个项目或打开以前的项目——请单击“新建文档”开始。你会看到有很多模板可供选择，但如果你向下滚动到底部，你会看到表格回归；请选择它并按下一步。对于项目名称，请输入 BetterRest，然后按 Next，选择您的桌面，然后按 Create。

这是 Create ML 一开始看起来有点棘手的地方，因为您会看到一个包含很多选项的屏幕。不过别担心——一旦我引导你完成它并不难。

第一步是为 Create ML 提供一些训练数据。这是它要查看的原始统计数据，在我们的案例中包含四个值：当某人想醒来时，他们认为自己喜欢睡多少觉，他们每天喝多少咖啡，以及他们睡了多少*实际*需要。

我在 BetterRest.csv 中为您提供了这些数据，该数据位于该项目的项目文件中。这是 Create ML 可以使用的逗号分隔值数据集，我们的首要任务是导入它。

因此，在 Create ML 中查看 Data 并在 Training Data 标题下选择“Select...”。当您再次按“选择...”时，它将打开一个文件选择窗口，您应该选择 BetterRest.csv。

**重要提示：**此 CSV 文件包含用于本项目目的的示例数据，不应用于实际的健康相关工作。

下一项工作是确定目标，即我们希望计算机学习预测的值，以及特征，即我们希望计算机检查以预测目标的值。例如，如果我们选择某人认为他们需要多少睡眠以及他们*实际*需要多少睡眠作为特征，我们可以训练计算机预测他们喝了多少咖啡。

在这种情况下，我希望您选择“actualSleep”作为目标，这意味着我们希望计算机学习如何预测他们实际需要多少睡眠。现在按选择功能，然后选择所有三个选项：唤醒、估计睡眠和咖啡——我们希望计算机在产生预测时考虑所有这三个选项。

Select Features 按钮下方是算法的下拉按钮，有五个选项：Automatic、Random Forest、Boosted Tree、Decision Tree 和 Linear Regression。每个都采用不同的方法来分析数据，但有一个自动选项可以帮助您自动选择最佳算法。它并不总是正确的，事实上它确实极大地限制了我们的选择，但对于这个项目来说，它已经足够好了。

**提示：**如果您想了解各种算法的作用，我专门为您准备了一个名为 Create ML for Everyone 的演讲——在 YouTube 上https://youtu.be/a905KIBw1hs

准备好后，单击窗口标题栏中的训练按钮。几秒钟后——我们的数据非常小！– 它将完成，您会看到一个大勾号，告诉您一切都按计划进行。

要查看培训的进展情况，请选择评估选项卡，然后选择验证以查看一些结果指标。我们关心的值称为均方根误差，您应该得到一个大约 170 的值。这意味着该模型平均能够预测建议的准确睡眠时间，误差仅为 170 秒或 3 分钟。

**提示：** Create ML 为我们提供了训练和验证统计数据，两者都很重要。当我们要求它使用我们的数据进行训练时，它会自动拆分数据：一些用于训练其机器学习模型，但随后它保留了一部分用于验证。然后使用此验证数据检查其模型：它根据输入进行预测，然后检查该预测与来自数据的实际值相差多远。

更好的是，如果您转到“输出”选项卡，您会看到我们完成的模型的文件大小为 544 字节左右。Create ML 获取了 180KB 的数据，并将其压缩到仅 544 字节——几乎没有。

现在，544 字节听起来很小，我知道，但值得补充的是，几乎所有这些字节都是元数据：作者姓名以及所有字段的名称都在其中：wake、estimatedSleep、coffee 和 actualSleep。

硬数据占用的实际空间量——如何根据我们的三个变量预测所需的睡眠量——远低于 100 字节。这是可能的，因为 Create ML 实际上并不关心值是什么，它只关心关系是什么。因此，它花费了数十亿个 CPU 周期为每个特征尝试各种权重组合，以查看哪些产生最接近实际目标的值，一旦它知道最佳算法，它就会简单地存储它。

现在我们的模型已经训练完成，我希望您按下 Get 按钮将其导出到您的桌面，以便我们可以在代码中使用它。

**提示：**如果您想再次尝试训练——也许是为了试验我们可用的各种算法——在左侧窗口中右键单击您的模型源，然后选择复制。



## 执行

#### [构建基本布局]

这个应用程序将允许用户使用日期选择器和两个步进器进行输入，它们结合起来会告诉我们他们什么时候想醒来，他们通常喜欢多少睡眠，以及他们喝了多少咖啡。

因此，请首先添加三个属性，让我们存储这些控件的信息：

```swift
@State private var wakeUp = Date.now
@State private var sleepAmount = 8.0
@State private var coffeeAmount = 1
```

在我们的内部，我们`body`将放置三组组件，分别包裹在 a`VStack`和 a 中`NavigationView`，所以让我们从唤醒时间开始。将默认的“Hello World”文本视图替换为：

```swift
NavigationView {
    VStack {
        Text("When do you want to wake up?")
            .font(.headline)

        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
            .labelsHidden()

        // more to come
    }
}
```

我们要求`.hourAndMinute`配置是因为我们关心某人想要醒来的时间而不是一天，并且使用`labelsHidden()`修饰符我们不会为选择器获得第二个标签——上面的一个就足够了。

接下来我们将添加一个步进器，让用户大致选择他们想要的睡眠时间。通过给这个东西一个0.25的`in`范围`4...12`和步长，我们可以确定它们会输入合理的值，但是我们可以将它与`formatted()`方法结合起来，这样我们就会看到像“8”而不是“8.000000”这样的数字。

添加此代码代替`// more to come`注释”

```swift
Text("Desired amount of sleep")
    .font(.headline)

Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
```

最后，我们将添加最后一个步进器和标签来处理他们喝了多少咖啡。这次我们将使用 1 到 20 的范围（因为肯定每天 20 杯咖啡对任何人来说都足够了？），但我们还将在步进器内显示两个标签之一，以更好地处理复数。如果用户将 a 设置`coffeeAmount`为 1，我们将显示“1 cup”，否则我们将使用该数量加上“cups”，所有这些都使用三元条件运算符决定。

`VStack`在前面的视图下方的 , 中添加这些：

```swift
Text("Daily coffee intake")
    .font(.headline)

Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
```

我们需要的最后一件事是一个按钮，让用户计算他们应该睡觉的最佳时间。我们可以在末尾添加一个简单的按钮`VStack`，但为了给这个项目增添一点趣味，我想尝试一些新的东西：我们将直接向导航栏添加一个按钮。

首先我们需要一个按钮调用的方法，所以添加一个空`calculateBedtime()`方法，如下所示：

```swift
func calculateBedtime() {
}
```

现在我们需要使用`toolbar()`修饰符将尾随按钮添加到导航视图。我们之前使用它和`ToolbarItemGroup`在键盘旁边放置一个按钮，但这里我们的需求要简单得多：我们只需要导航栏中的一个按钮，这可以通过直接向工具栏添加一个按钮来完成。

当我们在这里时，我们还不如使用`navigationTitle()`在顶部放置一些文本。

因此，将这些修饰符添加到`VStack`：

```swift
.navigationTitle("BetterRest")
.toolbar {
    Button("Calculate", action: calculateBedtime)
}
```

**提示：**对于从左到右的语言，例如英语，我们的按钮将自动放置在右上角，但对于从右到左的语言，将自动移动到另一侧。

那还不会做任何事情，因为它`calculateBedtime()`是空的，但至少我们的 UI 目前已经足够好了。

#### [将 SwiftUI 连接到 Core ML]

就像 SwiftUI 使用户界面开发变得容易一样，Core ML 使机器学习变得容易。多么容易？好吧，一旦你有一个训练有素的模型，你只需两行代码就可以得到预测——你只需要发送应该用作输入的值，然后读取返回的内容。

在我们的例子中，我们已经使用 Xcode 的 Create ML 应用程序制作了一个 Core ML 模型，所以我们将使用它。你应该已经把它保存在你的桌面上，所以现在请将它拖到 Xcode 中的项目导航器中。当 Xcode 提示您“如果需要，请复制项目”时，请确保选中该框。

当你向 Xcode 添加一个 .mlmodel 文件时，它会自动创建一个同名的 Swift 类。你看不到这个类，也不需要——它是作为构建过程的一部分自动生成的。但是，这*确实*意味着，如果您的模型文件命名为奇怪，那么自动生成的类名也将被命名为奇怪。

**不管你的模型文件有什么名字，请把它重命名为“SleepCalculator.mlmodel”，这样就可以调用自动生成的类`SleepCalculator`。**

我们如何确定这是类名？好吧，只需选择模型文件本身，Xcode 就会显示更多信息。你会看到它知道我们的作者，生成的 Swift 类的名称，加上输入列表及其类型，以及输出和类型 – 这些都被编码在模型文件中，这就是它的原因（相比之下！） 很大。

稍后我们将开始填写`calculateBedtime()`，但在此之前，我们需要为 CoreML 添加导入，因为我们正在使用 SwiftUI 之外的功能。

因此，滚动到 ContentView.swift 的顶部并将其添加到`import`SwiftUI 行之前：

```swift
import CoreML
```

**提示：**您并不一定需要在 SwiftUI 之前添加 CoreML，但保持导入按字母顺序排列会使以后更容易检查它们。

好的，现在我们可以转向`calculateBedtime()`. 首先，我们需要创建一个`SleepCalculator`类的实例，如下所示：

```swift
do {
    let config = MLModelConfiguration()
    let model = try SleepCalculator(configuration: config)

    // more code here
} catch {
    // something went wrong!
}
```

该模型实例是读取我们所有数据的东西，并将输出预测。如果您需要启用一些相当模糊的选项，则可以使用该配置——也许全职从事机器学习工作的人需要这些，但老实说，我猜只有千分之一的人真正使用这些选项。

我*确实*希望您关注`do`/`catch`块，因为使用 Core ML 可能会在两个地方引发错误：加载模型如上所示，以及当我们要求预测时。老实说，我想我一生中从未有过预测失败的经历，但安全并没有什么坏处！

无论如何，我们使用包含以下字段的 CSV 文件训练我们的模型：

- “wake”：当用户想要唤醒时。这表示为从午夜开始的秒数，因此上午 8 点将是 8 小时乘以 60 乘以 60，得到 28800。
- “estimatedSleep”：用户想要的大致睡眠时间，存储为从 4 到 12 的值，以四分之一为增量。
- “咖啡”：大概用户每天喝多少杯咖啡。

因此，为了从我们的模型中获得预测，我们需要填写这些值。

我们已经有了其中的两个，因为我们的`sleepAmount`and`coffeeAmount`属性已经足够好了——我们只需要将`coffeeAmount`整数转换为 a 就可以`Double`让 Swift 满意了。

但是计算唤醒时间需要更多的思考，因为我们的`wakeUp`属性是 a`Date`不代表`Double`秒数。有用的是，这就是 Swift`DateComponents`类型的用武之地：它将表示日期所需的所有部分存储为单独的值，这意味着我们可以读取小时和分钟组件并忽略其余部分。然后我们需要做的就是将分钟乘以 60（得到秒而不是分钟），然后将小时乘以 60 和 60（得到秒而不是小时）。

我们可以得到一个`DateComponents`从一个实例`Date`有一个非常具体的方法调用：`Calendar.current.dateComponents()`。然后我们可以请求小时和分钟组件，并传递我们的起床日期。返回的`DateComponents`实例具有其所有组件的属性——年、月、日、时区等——但其中大部分不会被设置。我们要求的小时和分钟*将*被设置，但将是可选的，因此我们需要仔细打开它们。

所以，把这个代替`// more code here`评论`calculateBedtime()`：

```swift
let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
let hour = (components.hour ?? 0) * 60 * 60
let minute = (components.minute ?? 0) * 60
```

如果无法读取小时或分钟，则该代码使用 0，但实际上这永远不会发生，因此它将导致`hour`并`minute`在几秒钟内设置为这些值。

下一步是将我们的价值观输入到 Core ML 中，看看结果如何。这是使用`prediction()`我们模型的方法完成的，该方法需要进行预测所需的唤醒时间、估计睡眠和咖啡量值，所有这些`Double`值都作为值提供。我们刚刚计算了我们的`hour`和`minute`作为秒，所以我们会在发送它们之前将它们加在一起。

请在前面的代码下面添加：

```swift
let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

// more code here
```

有了这个，`prediction`现在包含了他们实际需要多少睡眠。这几乎可以肯定不是我们模型看到的训练数据的一部分，而是由 Core ML 算法动态计算的。

但是，它对用户来说不是一个有用的值——它会是几秒钟内的某个数字。我们想要将其转换为他们应该上床睡觉的时间，这意味着我们需要从他们需要醒来的时间中减去以秒为单位的值。

多亏了 Apple 强大的 API，这只是一行代码——你可以直接从 a 中减去一个以秒为单位的值`Date`，你会得到一个新的`Date`！所以，在预测之后添加这行代码：

```swift
let sleepTime = wakeUp - prediction.actualSleep
```

现在我们确切地知道他们应该什么时候睡觉。至少目前，我们的最后一个挑战是向用户展示这一点。我们将通过警报来执行此操作，因为您已经学会了如何执行此操作并且可以使用该练习。

因此，首先添加三个属性来确定警报的标题和消息，以及是否显示：

```swift
@State private var alertTitle = ""
@State private var alertMessage = ""
@State private var showingAlert = false
```

我们可以立即在`calculateBedtime()`. 如果我们的计算出错——如果读取预测引发错误——我们可以`// something went wrong`用一些设置有用错误消息的代码替换注释：

```swift
alertTitle = "Error"
alertMessage = "Sorry, there was a problem calculating your bedtime."
```

无论预测是否有效，我们都应该显示警报。它可能包含他们的预测结果，也可能包含错误消息，但它仍然有用。所以，把这个在结束`calculateBedtime()`，*之后*的`catch`块：

```swift
showingAlert = true
```

如果预测成功，我们将创建一个名为的常量`sleepTime`，其中包含他们需要上床睡觉的时间。但这`Date`不是一个格式整齐的字符串，因此我们将通过该`formatted()`方法传递它以确保它是人类可读的，然后将其分配给`alertMessage`.

因此，将这些最后几行代码放入 中`calculateBedtime()`，直接在我们设置`sleepTime`常量的位置之后：

```swift
alertTitle = "Your ideal bedtime is…"
alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
```

要结束应用程序的这个阶段，我们只需要添加一个`alert()`显示`alertTitle`和`alertMessage`何时`showingAlert`变为真的修饰符。

请将此修饰符添加到我们的`VStack`：

```swift
.alert(alertTitle, isPresented: $showingAlert) {
    Button("OK") { }
} message: {
    Text(alertMessage)
}
```

现在继续运行应用程序——它可以工作了！它看起来不太*好*，但它确实有效。

#### [清理用户界面]

虽然我们的应用程序现在可以运行，但它不是你想要在 App Store 上发布的东西——它至少有一个主要的可用性问题，而且设计……嗯……让我们说“不合标准”。

让我们先看看可用性问题，因为您可能没有想到它。当您阅读时，`Date.now`它会自动设置为当前日期和时间。因此，当我们`wakeUp`使用新日期创建属性时，默认唤醒时间将是现在的任何时间。

尽管该应用程序需要能够处理任何类型的时间——例如，我们不想排除夜班人员——我认为可以肯定地说，早上 6 点到 8 点之间的默认唤醒时间将是对广大用户更有用。

为了解决这个问题，我们将向我们的`ContentView`结构添加一个计算属性，该属性包含一个`Date`引用当天早上 7 点的值。这非常简单：我们可以创建一个`DateComponents`自己的新`Calendar.current.date(from:)`组件，并使用它来将这些组件转换为完整的日期。

因此，将此属性添加到`ContentView`现在：

```swift
var defaultWakeTime: Date {
    var components = DateComponents()
    components.hour = 7
    components.minute = 0
    return Calendar.current.date(from: components) ?? Date.now
}
```

现在我们就可以利用它来进行的默认值`wakeUp`代替`Date.now`：

```swift
@State private var wakeUp = defaultWakeTime
```

如果您尝试编译该代码，您会看到它失败，原因是我们正在从另一个属性内部访问一个属性 - Swift 不知道属性将按哪个顺序创建，因此这是不允许的。

这里的修复很简单：我们可以创建`defaultWakeTime`一个静态变量，这意味着它属于`ContentView`结构本身，而不是该结构的单个实例。这反过来意味着`defaultWakeTime`可以随时读取，因为它不依赖于任何其他属性的存在。

因此，将属性定义更改为：

```swift
static var defaultWakeTime: Date {
```

这解决了我们的可用性问题，因为大多数用户会发现默认唤醒时间接近他们想要选择的时间。

至于我们的造型，这需要更多的努力。一个简单的改变是切换到 a`Form`而不是 a `VStack`。所以，找到这个：

```swift
NavigationView {
    VStack {
```

并将其替换为：

```swift
NavigationView {
    Form {
```

这立即使 UI 看起来更好——我们得到了一个清晰分段的输入表，而不是一些以空白为中心的控件。

我们的表单中仍然存在一个烦恼：表单中的每个视图都被视为列表中的一行，而实际上所有的文本视图都构成了同一个逻辑表单部分的一部分。

我们*可以*`Section`在这里使用视图，将我们的文本视图作为标题——您将在挑战中尝试使用它。相反，我们将用 a 包装每对文本视图和控件，`VStack`以便将它们视为一行。

继续将每一对包装在 a `VStack`now 中，`.leading`用于对齐，0 用于间距。例如，您将采用以下两个视图：

```swift
Text("Desired amount of sleep")
    .font(.headline)

Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
```

并将它们包装成`VStack`这样：

```swift
VStack(alignment: .leading, spacing: 0) {
    Text("Desired amount of sleep")
        .font(.headline)

    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
}
```

现在最后一次运行应用程序，因为它已经完成了——干得好！

## 挑战

#### [BetterRest：总结]

这个项目给你得到一些做法与形式和绑定，同时还推出你的机会`DatePicker`，`Stepper`，`Date`，`DateComponents`，多，同时也看到如何放置按钮进入导航栏-这些事情你将要使用的时间和时间再次，所以我想让他们早点好起来。

当然，我也借此机会向您展示了我们可以使用 Apple 的框架构建的一些令人难以置信的东西，这一切都归功于 Create ML 和 Core ML。如您所见，这些框架使我们能够利用数十年的机器学习研究和开发，所有这些都使用拖放用户界面和几行代码——这真的再简单不过了。

机器学习真正令人着迷的是它不需要使用大的或聪明的场景。您可以使用机器学习来预测二手车价格，找出用户笔迹，甚至检测图像中的人脸。最重要的是，整个过程发生在用户的设备上，完全保密。

#### 回顾你学到的东西

任何人都可以坐下来完成教程，但需要实际工作才能记住所教的内容。我的工作是确保你尽可能多地从这些教程中学习，所以我准备了一个简短的回顾来帮助你检查你的学习情况。

[单击此处查看您在此项目中学到的内容](https://www.hackingwithswift.com/review/ios-swiftui/betterrest)。

#### 挑战

学习的最佳方法之一是尽可能多地编写自己的代码，因此您应该尝试通过以下三种方式扩展此应用程序，以确保您完全理解正在发生的事情：

1. 用 替换`VStack`我们表单中的每个`Section`，其中文本视图是该部分的标题。你喜欢这个布局还是`VStack`布局？这是您的应用程序 - 您选择！
2. 将“杯数”步进器替换为`Picker`显示相同范围的值。
3. 更改用户界面，使其始终使用漂亮且大号的字体显示他们推荐的就寝时间。您应该能够完全删除“计算”按钮。

