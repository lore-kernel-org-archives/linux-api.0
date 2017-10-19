From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [1/2,v2] fdmap(2)
Date: Thu, 19 Oct 2017 17:34:35 +0200
Message-ID: <CACVxJT_AKQmd0ziP7jWQvfA5MQGJgC2q2VA3xyFjVARrQR-ekg@mail.gmail.com>
References: <20170924200620.GA24368@avx2> <20171010220804.GA30735@outlook.office365.com>
 <20171011181234.GB2119@avx2> <20171012080608.GA23077@outlook.office365.com>
 <CACVxJT_ZP=VAJQ_=D1JV0yt3bT_RZjtWTW61KcV5gCbhF8ixBw@mail.gmail.com> <CALCETrW769=r4uXH2RqoQ0cQL2CakfupwAUM2_81Fr8Mo3JX=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrW769=r4uXH2RqoQ0cQL2CakfupwAUM2_81Fr8Mo3JX=Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Andrei Vagin <avagin@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Djalal Harouni <tixxdz@gmail.com>, Alexey Gladkov <gladkov.alexey@gmail.com>
List-Id: linux-api@vger.kernel.org

On 10/18/17, Andy Lutomirski <luto@kernel.org> wrote:
>> fdmap() is standalone thing.
>>
>> Next step is to design fdinfo(2) (?) which uses descriptors from
>> fdmap(2). Extending structures is done as usual: but version,
>> add new fields to the end.
>
> I very strongly disagree.  If you really want a new interface for
> reading out information about other processes, design one that makes
> sense as a whole.  Don't design it piecemeal. The last thing we need
> is a crappy /proc alternative that covers a small fraction of use
> cases.

Oh well.

> And demonstrate that it actually has a material benefit over
> fixing /proc.

> Meanwhile, why not just fix /proc?

/proc can not be fixed. Let me reiterate the arguments one more time.

Using /proc
* overallocates memory even if temporarily,
* instantiates dentries and inodes nobody cares about,
* make expansion path more painful than necessary:
  1) adding field to the end of the file is the least risky move,
  2) decimal radix and unfixed positioning are used often
  3) read() doesn't accept any sort of filter for data

  (1)+(3) = those who added their fields later eat the cost of all
  previous fields even if their field is very simple and easy
  to calculate.

  (2)+(3) = lseek() can not be used as a substitute.

  4) adding new file is cleaner however every virtual file creates
     kernel objects which aren't interesting themselves.
     This has direct costs (more syscalls and lookups) and
     indirect costs (more garbage in d/icache and more flushing
     when the process dies)

  5) converting to strings eats cycles (and more cycles are consumed
     if userspace decides to convert it back to binary for whatever
     reasons)

     For those who didn't pay attention, first patch to make integer
     conversion faster made /proc/*/stat (?) 30% faster!
     This is how slow text can be.

Sysfs is overall better but solely because it has strict one-value-per-file
rule, so interfaces are cleaner and there is less room for mistakes.


Philosophically, text files create false impression that parsing text
is easy.

As an example grab a bunch of students and ask them to write a program
which parses something innocent like /proc/*/stat for process state.

The beartrap is that ->comm is not escaped for Space and ')' so naive
strchr() from the beginning doesn't work reliably. The only reliable
way is to count spaces from the end(!) and pray kernel devs do not
extend the file with another field or, worse, with another textual
field.

ESCAPE_SPACE doesn't escape Space, funny, isn't it?

/proc/*/status kind of has the same problem however forward strstr()
works with "\nState:\t" because \n and \t will be escaped. But nobody
would search for just "State:", especially in scripts, right?

EIATF people often critique binary people for their mistakes
but themselves make equally stupid ones. "(unreachable)" anyone?.

So the answer it not to fix /proc, the answer it to leave /proc alone.
The answer is make Unix shell people move their lazy asses and
implement minimal type system and a way to execute raw system calls
like all normal programming languages do. They still haven't done it
after dozens of years and are arrogant enough to say "oh uh we can't
use cat and pipe to awk".
