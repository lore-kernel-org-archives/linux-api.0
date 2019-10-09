From: David Howells <dhowells@redhat.com>
Subject: Re: [MANPAGE PATCH] Add manpage for fsinfo(2)
Date: Wed, 09 Oct 2019 13:02:20 +0100
Message-ID: <17943.1570622540@warthog.procyon.org.uk>
References: <515a67cd-f847-8885-da30-1eab3931f1fb@gmail.com> <153126269451.14533.13592791373864325188.stgit@warthog.procyon.org.uk> <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk> <15519.1531263314@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <515a67cd-f847-8885-da30-1eab3931f1fb@gmail.com>
Content-ID: <17942.1570622540.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, linux-man@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

Michael Kerrisk (man-pages) <mtk.manpages@gmail.com> wrote:

> There is no fsinfo(2) in the system call in the kernel currently.
> Will that call still be added,

Hopefully, but I'm not sure it'll be ready by the next merge window.

> or was it replaced by fsconfig(2),

They're different things and not interchangeable.

David
