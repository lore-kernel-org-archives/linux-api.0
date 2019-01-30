From: David Howells <dhowells@redhat.com>
Subject: Re: [RFD] A mount api that notices previous mounts
Date: Wed, 30 Jan 2019 12:50:54 +0000
Message-ID: <9151.1548852654@warthog.procyon.org.uk>
References: <87va2716mh.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87va2716mh.fsf@xmission.com>
Content-ID: <9150.1548852654.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: dhowells@redhat.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, Karel Zak <kzak@redhat.com>, util-linux@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

You need to rebase on linus/master.  A bunch of your patches are obsoleted by
Al's security changes there.

David
