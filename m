From: Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH v10 00/18] Introduce the Counter subsystem
Date: Sun, 7 Apr 2019 15:25:50 +0100
Message-ID: <20190407152550.451a7f63@archlinux>
References: <cover.1554184734.git.vilhelm.gray@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1554184734.git.vilhelm.gray@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: William Breathitt Gray <vilhelm.gray@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, fabrice.gasnier@st.com, benjamin.gaignard@st.com, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net, akpm@linux-foundation.org, david@lechnology.com, robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org, leoyang.li@nxp.com, daniel.lezcano@linaro.org, tglx@linutronix.de, thierry.reding@gmail.com, esben@haabendal.dk, linux-pwm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, patrick.havelange@essensium.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue,  2 Apr 2019 15:30:35 +0900
William Breathitt Gray <vilhelm.gray@gmail.com> wrote:

> Changes in v10:
>   - Fix minor typographical errors in documentation
>   - Merge the FlexTimer Module Quadrature decoder counter driver patches
> 
> This revision is functionally identical to the last; changes in this
> version were made to fix minor typos in the documentation files and also
> to pull in the new FTM quadrature decoder counter driver.
> 
> The Generic Counter API has been and is still in a feature freeze until
> it is merged into the mainline. The following features will be
> investigated after the merge: interrupt support for counter devices, and
> a character device interface for low-latency applications.

Hi William / al,

So the question is how to move this forwards?  I'm happy with how it turned
out and the existing drivers we had in IIO are a lot cleaner under
the counter subsystem (other than the backwards compatibility for those that
ever existed in IIO).  For those  not following closely the situation is:

1. Counter drivers never really fitted that well in IIO, because IIO is
focused on an abstraction of individual channels that just doesn't match
to these devices.  It's just the wrong model. 

2. William tried hard in earlier proposals to extend IIO to support these
devices well, but it became so convoluted and involved I advised him that
we were better off with a separate subsystem.  The amount of code overlap
between the core IIO support for counters and the reset of IIO was
become very small and it would have been a maintenance problem for both.
https://lwn.net/Articles/729363/ gives some of the history

3. The new subsystem introduced by this series is fairly simple, clean
and well aligned with the way these devices work. There are (I think)
4 initial drivers in this series from 4 different authors so it's got
some practical review that way!
There are a couple more drivers under development.  Right now, not
everyone is aware of this work and so we have had a few developers potentially
waste their time writing IIO drivers (which are then ported to this) rather
that starting with the counter subsystem.

So what we are after is more review, or agreement that we can move this
series forwards.  For now the intent is that the counter subsystem will
share the linux-iio mailing list etc but I don't think either William
or I have any particularly strong views on how we actually handle the
patches.  I'm more than happy to take them through the IIO tree, if that
works for everyone, particularly Greg as IIO goes through him after me.
Once it is in a release, the cross dependency is broken and we can think
about longer term approaches.

So Greg and others, how do we make progress here?  If there are any obvious
reviewers not on the CC list, please do draw their attention to this.

Thanks,

Jonathan

+CC linux-api as obviously one of the biggest areas for review is the new
userspace ABI.

> 
> Benjamin Gaignard (2):
>   counter: Add STM32 Timer quadrature encoder
>   dt-bindings: counter: Document stm32 quadrature encoder
> 
> Fabrice Gasnier (2):
>   counter: stm32-lptimer: add counter device
>   dt-bindings: counter: Adjust dt-bindings for STM32 lptimer move
> 
> Patrick Havelange (7):
>   include/fsl: add common FlexTimer #defines in a separate header.
>   drivers/pwm: pwm-fsl-ftm: use common header for FlexTimer #defines
>   drivers/clocksource: timer-fsl-ftm: use common header for FlexTimer
>     #defines
>   dt-bindings: counter: ftm-quaddec
>   counter: add FlexTimer Module Quadrature decoder counter driver
>   counter: ftm-quaddec: Documentation: Add specific counter sysfs
>     documentation
>   LS1021A: dtsi: add ftm quad decoder entries
> 
> William Breathitt Gray (7):
>   counter: Introduce the Generic Counter interface
>   counter: Documentation: Add Generic Counter sysfs documentation
>   docs: Add Generic Counter interface documentation
>   iio: 104-quad-8: Update license boilerplate
>   counter: 104-quad-8: Add Generic Counter interface support
>   counter: 104-quad-8: Documentation: Add Generic Counter sysfs
>     documentation
>   iio: counter: Add deprecation markings for IIO Counter attributes
> 
>  Documentation/ABI/testing/sysfs-bus-counter   |  230 +++
>  .../ABI/testing/sysfs-bus-counter-104-quad-8  |   36 +
>  .../ABI/testing/sysfs-bus-counter-ftm-quaddec |   16 +
>  Documentation/ABI/testing/sysfs-bus-iio       |    8 +
>  .../testing/sysfs-bus-iio-counter-104-quad-8  |   16 +
>  .../bindings/counter/ftm-quaddec.txt          |   18 +
>  .../{iio => }/counter/stm32-lptimer-cnt.txt   |    0
>  .../bindings/counter/stm32-timer-cnt.txt      |   31 +
>  .../devicetree/bindings/mfd/stm32-lptimer.txt |    2 +-
>  .../devicetree/bindings/mfd/stm32-timers.txt  |    7 +
>  Documentation/driver-api/generic-counter.rst  |  342 ++++
>  Documentation/driver-api/index.rst            |    1 +
>  MAINTAINERS                                   |   15 +-
>  arch/arm/boot/dts/ls1021a.dtsi                |   28 +
>  drivers/Kconfig                               |    2 +
>  drivers/Makefile                              |    1 +
>  drivers/clocksource/timer-fsl-ftm.c           |   15 +-
>  drivers/{iio => }/counter/104-quad-8.c        |  782 +++++++-
>  drivers/counter/Kconfig                       |   60 +
>  drivers/counter/Makefile                      |   10 +
>  drivers/counter/counter.c                     | 1567 +++++++++++++++++
>  drivers/counter/ftm-quaddec.c                 |  356 ++++
>  drivers/{iio => }/counter/stm32-lptimer-cnt.c |  361 +++-
>  drivers/counter/stm32-timer-cnt.c             |  390 ++++
>  drivers/iio/Kconfig                           |    1 -
>  drivers/iio/Makefile                          |    1 -
>  drivers/iio/counter/Kconfig                   |   34 -
>  drivers/iio/counter/Makefile                  |    8 -
>  drivers/pwm/pwm-fsl-ftm.c                     |   44 +-
>  include/linux/counter.h                       |  510 ++++++
>  include/linux/counter_enum.h                  |   45 +
>  include/linux/fsl/ftm.h                       |   88 +
>  32 files changed, 4877 insertions(+), 148 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-counter
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-counter-104-quad-8
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-counter-ftm-quaddec
>  create mode 100644 Documentation/devicetree/bindings/counter/ftm-quaddec.txt
>  rename Documentation/devicetree/bindings/{iio => }/counter/stm32-lptimer-cnt.txt (100%)
>  create mode 100644 Documentation/devicetree/bindings/counter/stm32-timer-cnt.txt
>  create mode 100644 Documentation/driver-api/generic-counter.rst
>  rename drivers/{iio => }/counter/104-quad-8.c (44%)
>  create mode 100644 drivers/counter/Kconfig
>  create mode 100644 drivers/counter/Makefile
>  create mode 100644 drivers/counter/counter.c
>  create mode 100644 drivers/counter/ftm-quaddec.c
>  rename drivers/{iio => }/counter/stm32-lptimer-cnt.c (51%)
>  create mode 100644 drivers/counter/stm32-timer-cnt.c
>  delete mode 100644 drivers/iio/counter/Kconfig
>  delete mode 100644 drivers/iio/counter/Makefile
>  create mode 100644 include/linux/counter.h
>  create mode 100644 include/linux/counter_enum.h
>  create mode 100644 include/linux/fsl/ftm.h
> 
