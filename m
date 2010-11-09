From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 20/23] netoops: Add x86 specific bits to packet headers
Date: Tue, 9 Nov 2010 09:56:02 -0800
Message-ID: <AANLkTik9i9pMqnngE-9t+Cc7cN6WbftjPoW6AWE6Va=x@mail.gmail.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
 <20101108203334.22479.71661.stgit@crlf.mtv.corp.google.com> <20101109142208.GB18269@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101109142208.GB18269-B26myB8xz7F8NnZeBjwnZQMhkBWG/bsMQH7oEaQurus@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Cc: simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 9, 2010 at 6:22 AM, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org> wro=
te:
> On Mon, Nov 08, 2010 at 12:33:35PM -0800, Mike Waychison wrote:
>> We need to be able to gather information about the CPUs that caused =
the crash.
>>
>> This commit only handles x86, but it is desirable to come up with so=
me new
>> packet format that can accommodate any architecture.
>>
>> Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> ---
>> TODO: This should be made more general to other architectures. =A0As=
 is, we are
>> probably okay exporting some value for the 'arch' field. =A0Differen=
t
>> architectures though will likely want to gather different data.
>> ---
>> =A0drivers/net/netoops.c | =A0 27 +++++++++++++++++++++------
>> =A01 files changed, 21 insertions(+), 6 deletions(-)
>>
> Not sure I see the value in encapsulating arch specific data in a net=
oops
> message. =A0Ostensibly this information can be inferred at the time o=
f the crash
> by the name/ip of the system crashing (one presumes that the sysadmin=
 knows what
> systems are what arch, or can look it up easily).

This actually becomes harder than it appears at first.  The
distributed nature of our systems means that we cannot ever rely on a
central data source that describes the machines we have without having
to worry about network partitions and service downtimes. The
alternative is to post-process crashes, looking up machine information
in various data sources and hoping that the results are consistent.
This becomes yet another job in the cluster, which seems a little
silly when we could just have the machine self describe itself at the
time of the crash.

>
> If thats not the case, why not just dump out the contents of /proc/cp=
uinfo in
> ascii form, so that no arch specific data is needed?

As a segment of the dump? I'm okay with doing this, as long it never
makes it's way into log_buf.  log_buf is a real pain to parse given
the lack of transactions and the fact that many other cores may be
scribbling all over it.

A couple years ago, we speced out a different wire protocol for these
packets, version 3 (yes, this has already had a version bump).
Anyhow, we came up with a design that used (key,length)->value fields.
  Keys were designed to be 16bit wide integers and clients could
easily ignore fields that it doesn't understand.  We never implemented
this, but it'd be great if folks bought into it.  It'd allow us to
ship things like file contents side by side with other structured
fields like pt_regs snapshots, the log_buf and a user defined buffer.

How do folks feel about something like that?
