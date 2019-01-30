From: Karel Zak <kzak@redhat.com>
Subject: Re: [RFD] A mount api that notices previous mounts
Date: Wed, 30 Jan 2019 13:06:54 +0100
Message-ID: <20190130120654.q5zqcexquca7u337@ws.net.home>
References: <87va2716mh.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87va2716mh.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, util-linux@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 29, 2019 at 03:44:22PM -0600, Eric W. Biederman wrote:
> so I am proposing we change this in the new mount api.

Well, this forces me to ask what the new API is? :-)

It seems that David uses fsconfig() and fsinfo() to set and get
mount options, and your patch introduces fsset() and fsoptions().

IMHO differentiate between FS driver and FS instance is a good idea it
makes things more extendable. The sequence number in the instance is a
good example.

But for me David's fsinfo() seems better that fsoptions() and
fsspecifier(). I'm not sure about "all mount options as one string"
>From your example is pretty obvious how much energy is necessary to 
split and join the strings.

It seems more elegant is to ask for Nth option as expected by fsinfo().
It also seems that fsinfo() is able to replace fsname() and fstype().

It would be better to extend David's fsinfo() to work with FS instance
and to return specifiers. And use fsconfig() rather than fsset().

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
