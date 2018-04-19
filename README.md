golang编码注意事项
1．new和make的区别,前者返回的是指针，后者返回引用，且make关键字只能创建channel、slice和map这三个引用类型。


2．如果User结构想实现Test方法，以下写法：func (this *User) Test() ，User的实例和*User都可以调到Test方法，不同的是作为接口时User没有实现Test方法


3．interface　作为两个成员实现，一个是类型和一个值， var x interface{} = (*interface{})(nil)　接口指针x不等于nil  。下面一段代码深入展示：
type User struct {

    Id   int

    Name string

    Tester

}

type Tester interface {

    Test()

}

func (this *User) Test() {

    fmt.Println(this)

}

func create() Tester {

    var x *User = nil

    return x

}

func main() {

    var x Tester = create()

    if x != nil {

        fmt.Println("not nil ")

    }

    var u *User = x.(*User)

    if u == nil {

        fmt.Println("nil ")

    }

}



4.继承通过嵌入实现，也可说go语言没有继承语法。


5.import关键字前面的"."和"_"的用法,点号表示调用这个包的函数时可以省去包名，下划线表示，纯引入包，因为go语法内没有使用这个包是不能导入的，包引入了，系统会自动调用包的init函数


6．select case必须是chan的io操作，为了避免饥饿问题，当多个通道都同时监听到数据时，select机制会随机性选择一个通道读取，
一个通道被多个select语句监听时，同理。

7.for select 组合用break语法是跳不出循环的，如果要跳出循环，要设置goto

8.goroutine的panic如果没有捕获，整个应用程序会crash ,所以安全起见每个复杂的go线都要recover


9．在函数退出时，defer的调用顺序是写在后面的先被调用。


10．init函数在main之前调用，被编译器自动调用，每个包理论上允许有多个init函数。

11.panic可以中断原有的控制流程，进入一个令人恐慌的流程中,这一过程继续向上，直到发生panic的goroutine中所有调用的函数返回，此时程序退出。恐慌可以直接调用panic产生。也可以由运行时错误产生，例如访问越界的数组.

recover的用法,recover可以让进入令人恐慌的流程中的goroutine恢复过来。recover仅在defer函数中有效。在正常的执行过程中，调用recover会返回nil，并且没有其它任何效果.


12.Array 和Slice的区别，Array就是一个数据块，值类型而非引用类型，传参时会进行内存拷贝，Slice是个reflect.SliceHeader结构体。Slice由make函数或者Array[:]创建。


13.闭包要注意循环调用时，upvalue值一不留意可能只是循环退出的值。如下代码：
func main() {

    var data int

    for i:= 0;i<10;i++{

    data ++

        go func(){

            listen2(data)

        }()

    }

    <- time.After(time.Second)

}


func listen2(data int) {

    fmt.Print( data)

}

输出：26101010101010106  ，跟你期望的输出可能不一样。


14.普通类型向接口类型的转换是隐式的,定义该接口变量直接赋值。接口类型向普通类型转换需要类型断言：value, ok := element.(T)。


15. Go设计上模糊了堆跟栈的边界，go编译器帮程序员做了对象逃逸分析，优化了内存分配，t := T{}是可以在函数里返回的，并不是像C语言中在栈里分配内存了


16.无论以接口或接口指针传递参数，接口指向的值都会被拷贝传递，引用类型（Map/Chan/Slice）拷贝该引用对象，值类型拷贝整个值（string除外）


17.go线程的调用时机是由系统决定的。

func main() {

    for i:= 0;i<10;i++{

        go listen2(i)

    }

    <- time.After(time.Second)

}

func listen2(data int) {

    fmt.Print( data)

}

以上代码输出：3456781209


18.调用log.Fatal系列函数后，会再调用 os.Exit(1)　退出程序，Fatal is equivalent to Print() followed by a call to os.Exit(1).

19.如果管道关闭则退出for循环，因为管道关闭不会阻塞导致for进入死循环,如下：
for {

        select {

        // 判断管道是否关闭

        case data, ok := <-readerChannel:

            if !ok {

                break

            }

            Log(string(data))

        }

    }


20. map,slice,array,chan的数据存取值类型数据都是值拷贝赋值，这个跟很多脚本语言不同，一定要注意
var list []mydata

var hash map[string]mydata

type mydata struct {

    A int

}

func main() {

list = make([]mydata, 1)

data := list[0]

data.A = 10

hash = make(map[string]mydata)

hash["test"] = mydata{}

data = hash["test"]

data.A = 10

fmt.Println(list[0].A, hash["test"].A)

}

这段代码的输出为：0 0


21.外部可见的属性必须是首字母大写，当转换到json数据是跟预期有偏差，必须添加json标签，如下：

type CMD struct{
        Cmd string `json:"cmd"`
        Data Data `json:"data"`
        UserId string `json:"userId"`
    }


22.包的循环引用编译错误，解决方法：提取公共部分到独立的包或者定义接口依赖注入。


23.return XXX 不是一条原子指令

思考下面的代码输出什么？
package main

import "fmt"

func main() {

fmt.Println(test())

fmt.Println(test1())

}

func test() (result int) {

defer func() {

result++

}()

return 1

}

func test1() (result int) {

t := 5

defer func() {

t = t + 5

}()

return t

}

结果为：
2
5
return XXX 不是一条原子指令，函数返回过程是，先对返回值赋值，再调用defer函数，然后返回调用函数
所以test方法的return 1可以拆分为：
result = 1
func()(result int){
    result ++
}()
return

24.内置copy方法，拷贝数组时，如果要整数组拷贝，目标数组长度要和源数组长度相同，否则剩下的数据不会被拷贝
list := []int{12, 1242, 35, 23, 534, 23, 1}

listNew := make([]int, 1, len(list))

copy(listNew, list)

for i := 0; i < len(listNew); i++ {

fmt.Println(listNew[i])

}

这段代码的输出为：12

25.分割切片slice时，新切片引用的内存和老切片引用的是同一块内存。
list := []int{12, 1242, 35, 23, 534, 23, 1}

listNew := list[:3]

listNew2 := list[:5]

listNew[1] = 999

fmt.Println(listNew2[1])

这段代码的输出为：999


26.编译时设置编译参数去掉调试信息，可以让生成体积更小：

go build  -o target.exe -ldflags "-w -s" source.go



27.golang语言里，string字符串类是不可变值类型，字符串的"+"连接操作、字符串和字符数组之间的转换string([]byte) 都会生成新的内存存放新字符串，当要对字符串频繁操作时做好先转换成字符数组。但是字符串作为参数传参时，此处go编译器作了优化，不会导致内存拷贝，引用的是同一块内存。


func main() {

very_long_string:= ""

    start := time.Now()

    for i := 0; i < 100000; i++ {

        very_long_string += "test " + "and test "

    }

    end := time.Now()

    delta := end.Sub(start)

    fmt.Println(delta, len(very_long_string))

}

上面代码打印耗时：18.7830743s 1400000



func main() {

very_long_string:= []byte{}

    start := time.Now()

    for i := 0; i < 100000; i++ {

        very_long_string = append(very_long_string,[]byte("test ")...)

        very_long_string = append(very_long_string,[]byte("and test ")...)

    }

    end := time.Now()

    delta := end.Sub(start)

    fmt.Println(delta, len(very_long_string))

}


上面代码打印耗时：6.0003ms 1400000

28.go build/run/test 有个参数 -race  ，设置-race运行时会进行数据竞态检测，并把关键代码打印输出，不过数据竞态不能全依赖race检测,不一定能全部检测出来。

29.如果非必要必要使用反射reflect和unsafe包内的函数，一定要使用时，要用runtime.KeepAlive函数告知SSA编译器在指定的代码段内不要回收该内存块。

30.不要打印整个map对象或者对象里有嵌套map的对象，打印函数会不加锁遍历map的每个元素，如果此时外部刚好有方法对map进行写操作，map就进入并发读写，runtime会panic.

31.注意range 循环迭代时key 的地址，for k,v:=range list  其中k 在迭代时指向同一个地址。
32.用append追加切片
如果slice还有剩余的空间，可以添加这些新元素，那么append就将新的元素放在slice后面的空余空间中；
如果slice的空间不足以放下新增的元素，那么就需要重现创建一个数组；这时可能是alloc、也可能是realloc的方式分配这个新的数组；
也就是说，这个新的slice可能和之前的slice在同一个起始地址上，也可能不是一个新的地址；
如果容量不足触发realloc，重新分配一个新的地址；
分配了新的地址之后，再把原来slice中的元素逐个拷贝到新的slice中，并返回；
触发realloc时，容量小于1024，会扩展w
 1原来的1倍，如果容量小大于1024，会扩展原来的1/4
33.很多打印函数打印结构体时回调用该结构体的String方法，所以String不能再打印本身这个对象。如下图：


34.for select 组合用break语法是跳不出循环的，如果要跳出循环，要设置goto 标签；
35. goroutine的panic如果没有捕获，整个应用程序会crash ,所以安全起见每个复杂的go线都要recover
36.map 并发读写的错误无法用panic捕获