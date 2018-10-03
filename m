From: Jann Horn <jannh@google.com>
Subject: Re: [RFC PATCH v4 24/27] mm/mmap: Create a guard area between VMAs
Date: Wed, 3 Oct 2018 18:52:40 +0200
Message-ID: <CAG48ez0KZYv9BECMm0-BNypJ232jrdkFp6_4VYTA=WoB-8w89w@mail.gmail.com>
References: <20180921150351.20898-1-yu-cheng.yu@intel.com> <20180921150351.20898-25-yu-cheng.yu@intel.com>
 <20181003045611.GB22724@asgard.redhat.com> <CALCETrU-Ny-uC1NqRedQwNKe2MMhsFEqZ08TtHJwbLfCACMmLw@mail.gmail.com>
 <5ddb0ad33298d1858e530fce9c9ea2788b2fac81.camel@intel.com> <20181003163226.GC9449@asgard.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181003163226.GC9449@asgard.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eugene Syromiatnikov <esyr@redhat.com>
Cc: yu-cheng.yu@intel.com, Andy Lutomirski <luto@amacapital.net>, the arch/x86 maintainers <x86@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, hjl.tools@gmail.com, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg
List-Id: linux-api@vger.kernel.org

On Wed, Oct 3, 2018 at 6:32 PM Eugene Syromiatnikov <esyr@redhat.com> wrote:
> On Wed, Oct 03, 2018 at 09:00:04AM -0700, Yu-cheng Yu wrote:
> > On Tue, 2018-10-02 at 22:36 -0700, Andy Lutomirski wrote:
> > > On Tue, Oct 2, 2018 at 9:55 PM Eugene Syromiatnikov <esyr@redhat.com> wrote:
> > > >
> > > > On Fri, Sep 21, 2018 at 08:03:48AM -0700, Yu-cheng Yu wrote:
> > > > > Create a guard area between VMAs, to detect memory corruption.
> > > >
> > > > Do I understand correctly that with this patch a user space program
> > > > no longer be able to place two mappings back to back? If it is so,
> > > > it will likely break a lot of things; for example, it's a common ring
> > > > buffer implementations technique, to map buffer memory twice back
> > > > to back in order to avoid special handling of items wrapping its end.
> > >
> > > I haven't checked what the patch actually does, but it shouldn't have
> > > any affect on MAP_FIXED or the new no-replace MAP_FIXED variant.
> > >
> > > --Andy
> >
> > I did some mmap tests with/without MAP_FIXED, and it works as intended.
> > In addition to the ring buffer, are there other test cases?
>
> Right, after some more code reading I figured out that it indeed
> shouldn't affect MAP_FIXED, thank you for confirmation.
>
> I'm not sure, however, whether such a change that provides no ability
> to configure or affect it will go well with all the supported
> architectures.

Is there a concrete reason why you think an architecture might not
like this? As far as I can tell, the virtual address space overhead
should be insignificant even for 32-bit systems.
