---
title: "类和接口"
---

类和接口是Java程序设计语言的核心，它们也是Java语言的基本抽象单元。Java语言提供了许多强大的基本元素，供程序员用来设计类和接口。本章阐述的一些指导原则，则可以帮助你更好地利用这些元素，设计出更加有用、健壮和灵活的类和接口。

## 第十三条：使类和成员的可访问性最小化
要区别设计良好的模块与设计不好的模块，最重要的因素在于，这个模块对于外部的其他模块而言，是否隐藏其内部数据和其他实现细节。设计良好的模块会隐藏所有的实现细节，把它的API和它的实现清晰地隔离开来。然后，模块之间只通过它们的API进行通信，一个模块不需要知道其他模块的内部工作情况。这个概念被称为信息隐藏（information hiding）或封装（encapsulation），是软件设计的基本原则之一[Parnas72]。

信息隐藏之所以非常重要有许多原因，其中大多数理由都源于这样一个事实：它可以有效地解除组成系统的各模块之间的耦合关系，使得这些模块可以独立地开发、测试、优化、使用、理解和修改。这样可以加快系统开发的速度，因为这些模块可以并行开发。它也减轻了维护的负担，因为程序员可以更快地理解这些模块，并且在调试它们的时候可以不影响其他的模块。虽然信息隐藏本身无论是对内还是对外，都不会带来更好的性能，但是它可以有效地调节性能：一旦完成一个系统，并通过剖析确定了哪些模块影响了系统的性能（见第55条），那些模块机就可以被进一步优化，而不会影响到其他模块的正确性。信息隐藏提高了软件的可重用性，因为模块之间并不紧密相连，除了开发这些模块所使用的环境之外，它们在其他的环境中往往也很有用。最后，信息隐藏也降低了构建大型系统的风险，因为即使整个系统不可用，但是这些独立的模块却有可能是可用的。

Java程序设计语言提供了许多机制（facility）来协助信息隐藏。访问控制（access acontrol）机制[JLS，6.6]决定了类、接口和成员的可访问性（accessibility）。实体的可访问性是由该实体声明所在的位置，以及该实体声明中所出现的访问修饰符（`private`、`protected`和`public`）共同决定的。正确地使用这些修饰符对于实现信息隐藏是非常关键的。

第一规则很简单：**尽可能地使每个类或者成员不被外界访问**。换句话说，应该使用与你正在编写的软件的对应功能相一致的、尽可能最小的访问级别。

对于顶层的（非嵌套的）类和接口，只有两种可能的访问级别：*包级私有的（package-private）* 和 *公有的（public）*。如果你用`public`修饰符声明了顶层类或者接口，那它就是公有的；否则，它将是包级私有的。如果类或者接口能够被做成包级私有的，它就应该被做成包级私有。通过把类或者接口做成包级私有，它实际上成了这个包的实现的一部分，而不是该包导出的API的一部分，在以后的发行版本中，可以对它进行修改、替换，或者删除，而无需担心会影响到现有的客户端程序。如果你把它做成公有的，你就有责任永远支持它，以保持它们的兼容性。

如果一个包级私有的顶层类（或者接口）只是在某一个类的内部被用到，就应该考虑使它成为唯一使用它的那个类的私有嵌套类（见第22条）。这样可以将它的可访问范围从包中的所有类缩小到了使用它的那个类。然而，降低不必要公有类的可访问性，比降低包级私有的顶 层类的更重要得多：因为公有类是包的API的一部分，而包级私有的顶层类则已经是这个包的实现的一部分。

对于成员（域、方法、嵌套类和嵌套接口）有四种可能的访问级别，下面按照可访问性的递增顺序罗列出来：

- **私有的（private）**—— 只有在声明该成员的顶层类内部才可以访问这个成员。
- **包级私有的（package-private）** —— 声明该成员的包内部的任何类都可以访问这个成员。从技术上讲，它被称为“缺省（default）访问级别”，如果没有为成员指定访问修饰符，就采用这个访问级别。
- **受保护的（protected）** —— 声明该成员的子类可以访问这个成员（但有一些限制 [JLS，6.6.2]），并且，声明该成员的包内部的任何类也可以访问这个成员。
- **公有的（public）** —— 在任何地方都可以访问该成员。

当你仔细地设计了类的公有API之后，可能觉得应该把所有其他的成员都变成私有的。其实，只有当同一个包内的另一个类真正需要访问一个成员的时候，你才应该删除`private`修饰符，使该成员编程包级私有的。如果你发现自己经常要做这样的的事情，就应该重新检查你的系统设计，看看是否另一种分解方案所得到的类，与其他类之间的耦合度会更小。也就是 说，私有成员和包级私有成员都是一个类的实现中的一部分，一般不会影响它的导出的API。 然而，如果这个类实现了`Serializable`接口（见第74和75条），这些域就有可能会被“泄露（leak）”到导出的API中。

对于公有类的成员，当访问级别从包级私有变成保护级别时，会大大增强可访问性。受保护的成员时类的导出的API的一部分，必须永远得到支持。导出的类的受保护成员也代表了该类对于某个实现细节的公开承诺（见第17条）。受保护的成员应该尽量少用。

有一条规则限制了降低方法的可访问性的能力。如果方法覆盖了超类中的一个方法，子类中的访问级别就不允许低于超类中的访问级别[JLS，8.4.8.3]。这样可以确保任何可使用超类的实例的地方也都可以使用子类的实例。如果你违反了这条规则，那么当你试图编译该子类的时候，编译器就会产生一条错误消息。这条规则有种特殊的情形：如果一个类实现了一个接口，那么接口中所有的类方法在这个类中也都必须被声明为公有的。之所以如此，是因为接口中所有方法都隐含着公有访问级别[JLS，9.1.5]。

为了便于测试，你可以试着使类、接口或者成员变得更容易访问。这么做在一定程度上来说是好的。为了测试而将一个公有类的私有成员变成包级私有的，这还可以接受，但是要将访问级别提高到超过它，这就无法接受了。换句话说，不能为了测试，而将类、接口或者成员 变成包的导出的API的一部分。幸运的是，也没有必要这么做，因为可以让测试作为被测试的包的一部分来运行，从而能够访问它的包级私有的元素。

**实例域决不能是公有的（见第14条）**。如果域是非`final`的，或者是一个指向可变对象的`final`引用，那么一旦使这个域成为公有的，就放弃了对存储在这个域中的值进行限制的能力；这意味着，你也放弃了强制这个域不可变的能力。同时，当这个域被修改的时候，你也失去了对它采取任何行动的能力。因此，包含公有可变域的类并不是线程安全的。即使域是`final`的，并且引用不可变对象，当把这个域编程公有的时候，也就放弃了“切换到一种新的内部数据表示法”的灵活性。

同样的建议也适用于静态域，只是有一种例外情况。假设常量构成了类提供的整个抽象中的一部分，可以通过公有的静态`final`域来暴露这些常量。按惯例，这种域的名称由大写字母组成，单词之间用下划线隔开（见第56条）。很重要的一点事，这些域要么包含基本类型的值，要么包含指向不可变对象的引用（见第15条）。如果`final`域包含可变对象的引用，她便具有非`final`域的所有去电。虽然引用本身不能被修改，但是它所引用的对象却可以被修改——这会导致灾难性的后果。

注意，长度非零的数组总是可变的，所以，**类具有公有的静态`final`数组域，或者返回这种域的访问方法，这几乎总是错误的**。如果类具有这样的域或者访问方法，客户端将能够修改数组中的内容。这是安全漏洞的一个常见根源：
```java
// Potential security hole!
public static final Thing[] VALUES = { ... };
```
要注意，许多IDE会产生返回指向私有数组域的引用的访问方法，这样就会产生这个问题。修正这个问题有两种方法。可以使公有数组变成私有的，并增加一个公有的不可变列表：
```java
private static final Thing[] PRIVATE_VALUES = { ... };
public static final List<Thing> VALUES =
    Collections.unmodifiableList(Arrays.asList(PRIVATE_VALUES));
```
另一种方法是，可以使数组变成私有的，并添加一个公有方法，它返回私有数组的一个备份：
```java
private static final Thing[] PRIVATE_VALUES = { ... };
public static final Thing[] values() {
    return PRIVATE_VALUES.clone();
}
```

要在这两种方法之间做出选择，得考虑客户端可能怎么处理这个结果。哪种返回类型会更加方便？哪种会得到更好的性能？

总而言之，你应该始终尽可能地降低可访问性。你在仔细地设计一个最小的公有API之后，应该防止把任何散乱的类、接口和成员变成API的一部分。除了公有静态`final`域的特殊情形之外，公有类都不应该包含公有域。并且要确保公有静态`final`域所引用的对象都是不可变的。

## 第十四条：在公有类中使用访问方法而非公有域

说到公有类的时候，坚持面向对象程序设计思想的看法是正确的：**如果类可以在它所在的包的外部进行访问，就提供访问方法**，以保留将来改变该类的内部表示法的灵活性。如果公有类暴露了它的数据域，要想在将来改变其内部表示法是不可能的，因为公有类的客户端代码已经遍布各处了。

然而，**如果类是包级私有的，或者是私有的嵌套类，直接暴露它的数据域并没有本质的错误**——假设这些数据域确实描述了该类所提供的抽象。这种方法比访问方法的做法更不会产生视觉混乱，无论实在类定义中，还是在使用类的客户端代码中。虽然客户端代码与该类的内部表示法紧密相连，但是这些代码被先定在包含该类的包中。如有必要，不改变包之外的任何代码而只改变内部数据表示法也是可以的。在私有嵌套类的情况下，改变的作用范围被进一步限制在外围类中。

Java平台类库中有几个类违反了“公有类不应该直接暴露数据域”的告诫。显著的例子包括 `java.awt`包中的`Point`和`Dimension`类。它们是不值得效仿的例子，相反，这些类应该被当做反面的警告示例。正如第55条中所讲述的，决定暴露`Dimension`类的内部数据造成了严重的性能问题，而且，这个问题至今依然存在。

让公有类直接暴露域虽然从来都不是种好办法，但是如果域是不可变的，这种做法的危害就比较小一些。如果不改变类的API，就无法改变这种类的表示法，当域被读取的时候，你也无法采取辅助的行动，但是可以强加约束条件。例如，这个类确保了每个实例都表示一个有效的时间：

```java
// Public class with exposed immutable fields - questionable
public final class Time {
    private static final int HOURS_PER_DAT= 24;
    private static final int MINUTES_PER_HOUR = 60;

    public final int hour;
    public final int minute;

    public Time(int hour, int minute) {
        if (hour < 0 || hour >= HOURS_PER_DAT)
            throw new IllegalArgumentException("Hour: " + hour);
        if (minute < 0 || minute >= MINUTES_PER_HOUR)
            throw new IllegalArgumentException("Min: " + minute);
        this.hour = hour;
        this.minute = minute;
    }
    ... // Remainder omitted
}
```
总之，公有类永远都不应该暴露可变的域。虽然还是有问题，但是让公有类暴露不可变的域其危害比较小。但是，有时候会需要用包级私有的或者私有的嵌套类来暴露域，无论这个类是可变的还是不可变的。

## 第十五条：使可变性最小化

不可变类只是其实例不能被修改的类。每个实例中包含的所有信息都必须在创建该实例的时候就提供，并在对象的整个生命周期（lifetime）内固定不变。Java平台类库中包含许多不可变的类，其中有`String`、基本类型的包装类、 `BigInteger`和`BigDecimal`。存在不可变的类有许多理由：不可变的类比可变类更加易于设计、实现和使用。它们不容易出错，且更加安全。

为了使类成为不可变，要遵循下面五条规则：

1. **不要提供任何会修改对象状态的方法（也称为mutator）**。[编辑注：即改变对象属性的方法]
2. **保证类不会被扩展**。这样可以防止粗心或者恶意的子类假装对象的状态已经改变，从而破坏该类的不可变行为。为了防止子类化，一般做法是使这个类成为`final`的，但是后面我们还会讨论到其他的做法。
3. **使所有的域都是`final`的**。通过系统的强制方式，这可以清楚地表明你的意图。而且，如果一个指向新创建实例的引用在缺乏同步机制的情况下，从一个线程被传递到另一个线程，就必需确保正确的行为，正如内存模型（memory model）中所述[JLS，17.5；Goetzo6 16]。
4. **使所有的域都成为私有的**。这样可以防止客户端获得访问被域引用的可变对象的权限，并防止客户端直接修改这些对象。虽然从技术上讲，允许不可变的类具有公有的`final`域，只要这些域包含基本类型的值或者指向不可变对象的引用，但是不建议这样做，因为这样会使得在以后的版本中无法再改变内部的表示法（见第13条）。
5. **确保对于任何可变组件的互斥访问**。如果类具有指向可变对象的域，则必须确保该类的客户端无法获得指向这些对象的引用。并且，永远不要用客户端提供的对象引用来初始化这样的域，也不要从任何访问方法（accessor）中返回该对象引用。在构造器、访问方法和 readObject 方法（见第76条）中请使用保护性拷贝（defensive copy）技术（见第39条）。

前面条目中的许多例子都是不可变的，其中一个例子是第9条中的`PhoneNumber`，它针对每个属性都有访问方法（accessor），但是没有对应的设值方法（mutator）。下面是个稍微复杂一点的例子：

```java
public final class Complex {
    private final double re;
    private final double im;

    public Complex(double re, double im) {
        this.re = re;
        this.im = im;
    }

    // Accessors with no corresponding mutators
    public double realPart()           { return re; }
    public double imaginaryPart()      { return im; }

    public Complex add(Complex c) {
        return new Complex(re + c.re, im + c.im);
    }

    public Complex subtract(Complex c) {
        return new Complex(re - c.re, im - c.im);
    }

    public Complex multiply(Complex c) {
        return new Complex(re * c.re - im * c.im,
                            re * c.re + im * c.im);
    }

    public Complex divide(Complex c) {
        double tmp = c.re * c.re + c.im * c.im;
        return new Complex((re * c.re + im * c.im) / tmp,
                            (im * c.re - re * c.im) / tmp);
    }

    @Override public boolean equals(Object o) {
        if (o == this)
            return true;
        if (!(o instanceof Complex))
            return false;
        Complex c = (Complex) o;

        // See page 43 to find out why we use compare instead of ==
        return Double.compare(re, c.re) == 0 &&
                Double.compare(im, c.im) == 0;
    }

    @Override public int hashCode() {
        int result = 17 + hashDouble(re);
        result = 31 * result + hashDouble(im);
        return result;
    }

    private int hashDouble(double val) {
        long longBits = Double.doubleToLongBits(re);
        return (int) (longBits ^ (longBits >>> 32));
    }

    @Override public String toString() {
        return "(" + re + " + " + im + "i)";
    }
}
```

这个类表示一个复数（complex number，具有实部和虚部）。除了标准