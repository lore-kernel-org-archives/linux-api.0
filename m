From: David Howells <dhowells@redhat.com>
Subject: Re: [RFD] A mount api that notices previous mounts
Date: Wed, 30 Jan 2019 13:01:54 +0000
Message-ID: <9871.1548853314@warthog.procyon.org.uk>
References: <20190130120654.q5zqcexquca7u337@ws.net.home> <87va2716mh.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190130120654.q5zqcexquca7u337@ws.net.home>
Content-ID: <9870.1548853314.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Karel Zak <kzak@redhat.com>
Cc: dhowells@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, util-linux@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

Karel Zak <kzak@redhat.com> wrote:

> It seems more elegant is to ask for Nth option as expected by fsinfo().

More elegant yes, but there's an issue with atomiticity[*].  I'm in the
process of switching to something that returns you a single buffer with all
the options in, but each key and each value is preceded by a length count.

The reasons for not using separator characters are:

 (1) There's no separator char that cannot validly occur within an option[**].

 (2) Makes it possible to return binary values if we need to.

David

[*] Atomic with respect to remount calls, that is.

[**] Oh, and look at cifs where you can *change* the separator char during
     option parsing ("sep=<char>").
