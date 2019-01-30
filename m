From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFD] A mount api that notices previous mounts
Date: Wed, 30 Jan 2019 07:45:31 -0600
Message-ID: <877eemqmx0.fsf@xmission.com>
References: <87va2716mh.fsf@xmission.com>
        <20190130120654.q5zqcexquca7u337@ws.net.home>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190130120654.q5zqcexquca7u337@ws.net.home> (Karel Zak's
        message of "Wed, 30 Jan 2019 13:06:54 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Karel Zak <kzak@redhat.com>
Cc: linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, util-linux@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

Karel Zak <kzak@redhat.com> writes:

> On Tue, Jan 29, 2019 at 03:44:22PM -0600, Eric W. Biederman wrote:
>> so I am proposing we change this in the new mount api.
>
> Well, this forces me to ask what the new API is? :-)
>
> It seems that David uses fsconfig() and fsinfo() to set and get
> mount options, and your patch introduces fsset() and fsoptions().
>
> IMHO differentiate between FS driver and FS instance is a good idea it
> makes things more extendable. The sequence number in the instance is a
> good example.
>
> But for me David's fsinfo() seems better that fsoptions() and
> fsspecifier(). I'm not sure about "all mount options as one string"
> From your example is pretty obvious how much energy is necessary to 
> split and join the strings.
>
> It seems more elegant is to ask for Nth option as expected by fsinfo().
> It also seems that fsinfo() is able to replace fsname() and fstype().
>
> It would be better to extend David's fsinfo() to work with FS instance
> and to return specifiers. And use fsconfig() rather than fsset().

As David has pointed out with cifs having a sep= option we need a better
story of parsing the options in the kernel.

What my branch does is demonstrate there is at least one way we can
avoid mount options being silently different from what userspace
expects.

Which means my branch is fine for looking at semantics and possible
system calls, but not much else.

I actually used multiple system calls just so I could avoid dealing
with multi-plexor systems calls.

Eric
