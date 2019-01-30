From: Karel Zak <kzak@redhat.com>
Subject: Re: [RFD] A mount api that notices previous mounts
Date: Wed, 30 Jan 2019 18:43:06 +0100
Message-ID: <20190130174306.4nbrh2m53re35qch@ws.net.home>
References: <20190130120654.q5zqcexquca7u337@ws.net.home>
 <87va2716mh.fsf@xmission.com>
 <9871.1548853314@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9871.1548853314@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, util-linux@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 30, 2019 at 01:01:54PM +0000, David Howells wrote:
> Karel Zak <kzak@redhat.com> wrote:
> 
> > It seems more elegant is to ask for Nth option as expected by fsinfo().
> 
> More elegant yes, but there's an issue with atomiticity[*].  I'm in the
> process of switching to something that returns you a single buffer with all
> the options in, but each key and each value is preceded by a length count.

Sounds good, for me is important to avoid all the split/join
operations with the strings.

> The reasons for not using separator characters are:
> 
>  (1) There's no separator char that cannot validly occur within an option[**].

Yes, it's pretty common for selinux mount options where "," is
used within an option, so mount options string looks like

    'context="system_u:object_r:tmp_t:s0:c127,c456",noexec'

and I have doubts all the parses in userspace are compatible with this
use case...

>  (2) Makes it possible to return binary values if we need to.

Yes.

> [**] Oh, and look at cifs where you can *change* the separator char during
>      option parsing ("sep=<char>").

No comment :-)

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
