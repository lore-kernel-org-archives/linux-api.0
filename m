From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v3 1/2] sysctl: handle overflow in proc_get_long
Date: Wed, 17 Oct 2018 02:24:57 +0200
Message-ID: <CAHrFyr6AeZzfGkQneiyoLz6YZ-vnyyQWTtc0HK-tqVJkoXt=4w@mail.gmail.com>
References: <20181016223322.16844-1-christian@brauner.io> <20181016223322.16844-2-christian@brauner.io>
 <877eihjw0n.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <877eihjw0n.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Joe Lawrence <joe.lawrence@redhat.com>, Waiman Long <longman@redhat.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 17, 2018 at 1:46 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Christian Brauner <christian@brauner.io> writes:
>
> > proc_get_long() is a funny function. It uses simple_strtoul() and for a
> > good reason. proc_get_long() wants to always succeed the parse and return
> > the maybe incorrect value and the trailing characters to check against a
> > pre-defined list of acceptable trailing values.
> > However, simple_strtoul() explicitly ignores overflows which can cause
> > funny things like the following to happen:
> >
> > echo 18446744073709551616 > /proc/sys/fs/file-max
> > cat /proc/sys/fs/file-max
> > 0
> >
> > (Which will cause your system to silently die behind your back.)
> >
> > On the other hand kstrtoul() does do overflow detection but does not return
> > the trailing characters, and also fails the parse when anything other than
> > '\n' is a trailing character whereas proc_get_long() wants to be more
> > lenient.
> >
> > Now, before adding another kstrtoul() function let's simply add a static
> > parse strtoul_lenient() which:
> > - fails on overflow with -ERANGE
> > - returns the trailing characters to the caller
> >
> > The reason why we should fail on ERANGE is that we already do a partial
> > fail on overflow right now. Namely, when the TMPBUFLEN is exceeded. So we
> > already reject values such as 184467440737095516160 (21 chars) but accept
> > values such as 18446744073709551616 (20 chars) but both are overflows. So
> > we should just always reject 64bit overflows and not special-case this
> > based on the number of chars.
> >
> > Acked-by: Kees Cook <keescook@chromium.org>
> > Signed-off-by: Christian Brauner <christian@brauner.io>
> > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > ---
> > v2->v3:
> > - (Kees) s/#include <../lib/kstrtox.h>/#include "../lib/kstrtox.h"/g
> > - (Kees) document strtoul_lenient()
> >
> > v1->v2:
> > - s/sysctl_cap_erange/sysctl_lenient/g
> > - consistenly fail on overflow
> >
> > v0->v1:
> > - s/sysctl_strtoul_lenient/strtoul_cap_erange/g
> > - (Al) remove bool overflow return argument from strtoul_cap_erange
> > - (Al) return ULONG_MAX on ERANGE from strtoul_cap_erange
> > - (Dominik) fix spelling in commit message
> > ---
> >  kernel/sysctl.c | 40 +++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 39 insertions(+), 1 deletion(-)
> >
> > diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> > index cc02050fd0c4..102aa7a65687 100644
> > --- a/kernel/sysctl.c
> > +++ b/kernel/sysctl.c
> > @@ -68,6 +68,8 @@
> >  #include <linux/mount.h>
> >  #include <linux/pipe_fs_i.h>
> >
> > +#include "../lib/kstrtox.h"
> > +
> >  #include <linux/uaccess.h>
> >  #include <asm/processor.h>
> >
> > @@ -2065,6 +2067,41 @@ static void proc_skip_char(char **buf, size_t *size, const char v)
> >       }
> >  }
> >
> > +/**
> > + * strtoul_lenient - parse an ASCII formatted integer from a buffer and only
> > + *                   fail on overflow
> > + *
> > + * @cp: kernel buffer containing the string to parse
> > + * @endp: pointer to store the trailing characters
> > + * @base: the base to use
> > + * @res: where the parsed integer will be stored
> > + *
> > + * In case of success 0 is returned and @res will contain the parsed integer,
> > + * @endp will hold any trailing characters.
> > + * This function will fail the parse on overflow. If there wasn't an overflow
> > + * the function will defer the decision what characters count as invalid to the
> > + * caller.
> > + */
> > +static int strtoul_lenient(const char *cp, char **endp, unsigned int base,
> > +                        unsigned long *res)
> > +{
> > +     unsigned long long result;
> > +     unsigned int rv;
> > +
> > +     cp = _parse_integer_fixup_radix(cp, &base);
> > +     rv = _parse_integer(cp, base, &result);
> > +     if ((rv & KSTRTOX_OVERFLOW) || (result != (unsigned long)result))
> > +             return -ERANGE;
> > +
> > +     cp += rv;
> > +
> > +     if (endp)
> > +             *endp = (char *)cp;
> > +
> > +     *res = (unsigned long)result;
> > +     return 0;
> > +}
> > +
> >  #define TMPBUFLEN 22
> >  /**
> >   * proc_get_long - reads an ASCII formatted integer from a user buffer
> > @@ -2108,7 +2145,8 @@ static int proc_get_long(char **buf, size_t *size,
> >       if (!isdigit(*p))
> >               return -EINVAL;
> >
> > -     *val = simple_strtoul(p, &p, 0);
> > +     if (strtoul_lenient(p, &p, 0, val))
> > +             return -EINVAL;
>
> Is it deliberate that on an error stroul_lenient returns -ERANGE but
> then proc_get_long returns -EINVAL?  That feels wrong.  The write system

Yes, because all other integer parsing function return ERANGE as well.
Right now there are no other users but if someone wants to use that function
I wanted it to behave like the others.

> call does not permit -ERANGE or -EINVAL for the contents of the data
> so both options appear equally bad from a standards point of view.

Right, but if you write a value that exceeds the buffer of 22 chars that is used
to parse you already get EINVAL back on current kernels.
So it didn't feel like returning EOVERFLOW or ERANGE might make sense.
I saw a change in 4.10 or 4.11 as well that used EINVAL on UINT_MAX overflow
or something. EINVAL might be enough information for userspace here ?/.

>
> I am just wondering what the thinking is here.
>
> >       len = p - tmp;
