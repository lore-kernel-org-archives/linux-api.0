From: Elichai Turkel <elichai.turkel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Including both linux/time.h and linux/input.h causes failure
Date: Wed, 29 Jan 2020 17:14:18 +0200
Message-ID: <CALN7hC+f+D8xsaJBt+MCXDfk51oHCoQeUVmFydNdkW+_DeqTiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,
The following header: <wrapper.h>:
```
#include <linux/input.h>
#include <linux/time.h>
```
Will cause the compiler to fail because of redefinition of a lot of
time related structs, that are declared once in `linux/time.h` and
then again via `bits/types/struct_timeval.h` which is included through
`linux/input.h > sys/time.h -> bits/types/struct_timeval.h`



Command: `gcc -I./headers_install/x86/include wrapper.h`
output:
```
In file included from wrapper.h:13:
./headers_install/x86/include/linux/time.h:16:8: error: redefinition
of =E2=80=98struct timeval=E2=80=99
   16 | struct timeval {
      |        ^~~~~~~
In file included from /usr/include/sys/time.h:25,
                 from ./headers_install/x86/include/linux/input.h:13,
                 from wrapper.h:8:
/usr/include/bits/types/struct_timeval.h:8:8: note: originally defined here
    8 | struct timeval
      |        ^~~~~~~
In file included from wrapper.h:13:
./headers_install/x86/include/linux/time.h:21:8: error: redefinition
of =E2=80=98struct timezone=E2=80=99
   21 | struct timezone {
      |        ^~~~~~~~
In file included from ./headers_install/x86/include/linux/input.h:13,
                 from wrapper.h:8:
/usr/include/sys/time.h:52:8: note: originally defined here
   52 | struct timezone
      |        ^~~~~~~~
In file included from wrapper.h:13:
./headers_install/x86/include/linux/time.h:30: warning: "ITIMER_REAL" redef=
ined
   30 | #define ITIMER_REAL  0
      |
In file included from ./headers_install/x86/include/linux/input.h:13,
                 from wrapper.h:8:
/usr/include/sys/time.h:92: note: this is the location of the previous
definition
   92 | #define ITIMER_REAL ITIMER_REAL
      |
In file included from wrapper.h:13:
./headers_install/x86/include/linux/time.h:31: warning:
"ITIMER_VIRTUAL" redefined
   31 | #define ITIMER_VIRTUAL  1
      |
In file included from ./headers_install/x86/include/linux/input.h:13,
                 from wrapper.h:8:
/usr/include/sys/time.h:95: note: this is the location of the previous
definition
   95 | #define ITIMER_VIRTUAL ITIMER_VIRTUAL
      |
In file included from wrapper.h:13:
./headers_install/x86/include/linux/time.h:32: warning: "ITIMER_PROF" redef=
ined
   32 | #define ITIMER_PROF  2
      |
In file included from ./headers_install/x86/include/linux/input.h:13,
                 from wrapper.h:8:
/usr/include/sys/time.h:99: note: this is the location of the previous
definition
   99 | #define ITIMER_PROF ITIMER_PROF
      |
In file included from wrapper.h:13:
./headers_install/x86/include/linux/time.h:39:8: error: redefinition
of =E2=80=98struct itimerval=E2=80=99
   39 | struct itimerval {
      |        ^~~~~~~~~
In file included from ./headers_install/x86/include/linux/input.h:13,
                 from wrapper.h:8:
/usr/include/sys/time.h:104:8: note: originally defined here
  104 | struct itimerval
      |        ^~~~~~~~~

```

--=20
PGP: 5607C93B5F86650C
