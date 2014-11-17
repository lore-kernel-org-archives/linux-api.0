From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [musl] Re: [RFC] Possible new execveat(2) Linux syscall
Date: Mon, 17 Nov 2014 15:42:15 +0000
Message-ID: <CAHse=S8uceX-buoeFoA_Qthsr0TZ-nX7_x_098qqwr5pa_2r-w@mail.gmail.com>
References: <CAHse=S8ccC2No5EYS0Pex=Ng3oXjfDB9woOBmMY_k+EgxtODZA@mail.gmail.com>
 <20141116195246.GX22465@brightrain.aerifal.cx> <CALCETrWWUyizL8HxZKaYE+xuV5eGi8mQcequT9HPvvac=X-dLg@mail.gmail.com>
 <20141116220859.GY22465@brightrain.aerifal.cx> <CALCETrVtN73rTxGXV9Xt+sPOitAWCcyrfUWY_3_tAmd+n6V1gA@mail.gmail.com>
 <20141116233202.GA22465@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141116233202.GA22465-C3MtFaGISjmo6RMmaWD+6Sb1p8zYI1N1@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, libc-alpha <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, musl-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 16, 2014 at 11:32 PM, Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org> wrote:
> On Sun, Nov 16, 2014 at 02:34:32PM -0800, Andy Lutomirski wrote:
>> On Sun, Nov 16, 2014 at 2:08 PM, Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org> wrote:
>> > On Sun, Nov 16, 2014 at 01:20:39PM -0800, Andy Lutomirski wrote:
>> >> On Nov 16, 2014 11:53 AM, "Rich Felker" <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org> wrote:
>> >> >
>> >> > On Fri, Nov 14, 2014 at 02:54:19PM +0000, David Drysdale wrote:
>> >> > > Hi,
>> >> > >
>> >> > > Over at the LKML[1] we've been discussing a possible new syscall, execveat(2),
>> >> > > and it would be good to hear a glibc perspective about it (and whether there
>> >> > > are any interface changes that would make it easier to use from userspace).
>> >> > >
>> >> > > The syscall prototype is:
>> >> > >   int execveat(int fd, const char *pathname,
>> >> > >                       char *const argv[],  char *const envp[],
>> >> > >                       int flags); /* AT_EMPTY_PATH, AT_SYMLINK_NOFOLLOW */
>> >> > > and it works similarly to execve(2) except:
>> >> > >  - the executable to run is identified by the combination of fd+pathname, like
>> >> > >    other *at(2) syscalls
>> >> > >  - there's an extra flags field to control behaviour.
>> >> > > (I've attached a text version of the suggested man page below)
>> >> > >
>> >> > > One particular benefit of this is that it allows an fexecve(3) implementation
>> >> > > that doesn't rely on /proc being accessible, which is useful for sandboxed
>> >> > > applications.  (However, that does only work for non-interpreted programs:
>> >> > > the name passed to a script interpreter is of the form "/dev/fd/<fd>/<path>"
>> >> > > or "/dev/fd/<fd>", so the executed interpreter will normally still need /proc
>> >> > > access to load the script file).
>> >> > >
>> >> > > How does this sound from a glibc perspective?
>> >> >
>> >> > I've been following the discussions so far and everything looks mostly
>> >> > okay. There are still issues to be resolved with the different
>> >> > semantics between Linux O_PATH and what POSIX requires for O_EXEC (and
>> >> > O_SEARCH) but as long as the intent is that, once O_EXEC is defined to
>> >> > save the permissions at the time of open and cause them to be used in
>> >> > place of the current file permissions at the time of execveat
>> >>
>> >> Is something missing here?
>> >>
>> >> FWIW, I don't understand O_PATH or O_EXEC very well, so from my POV,
>> >> help would be appreciated.
>> >
>> > Yes. POSIX requires that permission checks for execution (fexecve with
>> > O_EXEC file descriptors) and directory-search (*at functions with
>> > O_SEARCH file descriptors) succeed if the open operation succeeded --
>> > the permissions check is required to take place at open time rather
>> > than at exec/search time. There's a separate discussion about how to
>> > make this work on the kernel side.

I'm not familiar with O_EXEC either, I'm afraid, so to be clear -- does
O_EXEC mean the permission check is explicitly skipped later, at execute
time?  In other words, if you open(O_EXEC) an executable then remove the
execute bit from the file, does a subsequent fexecve() still work?

If it does, then from an implementation perspective that presumably implies
the need for a record of the permission check in the struct file (and that
this property would be inherited by any dup()ed file descriptors).  From a
security perspective, having a gap between time-of-check and time-of-use
always sounds worrying...

>>
>> It may be worth making this work as part of adding execveat to the
>> kernel.  Does the kernel even have O_EXEC right now?
>
> No. The proposal is that O_EXEC and O_SEARCH would both be equal to
> O_PATH|3 (3 being the rarely-used O_ACCMODE for "neither read or
> write, but some weird ioctls are accepted") which gracefully falls
> back for both current kernels with O_PATH (in which case the 3 is
> ignored and the discrepency from POSIX is just the time at which
> permissions are checked) and for pre-O_PATH kernels (in which case the
> access mode used is 3, and read/write ops fail on the fd, but it's
> still usable for fexecve and *at functions with /proc-based fallback
> implementations).
>
> I would be happy to see this work get done at the same time.
