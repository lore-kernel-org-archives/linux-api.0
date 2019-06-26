From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 00/25] VFS: Introduce filesystem information query syscall [ver #14]
Date: Wed, 26 Jun 2019 15:31:37 +0100
Message-ID: <9360.1561559497@warthog.procyon.org.uk>
References: <20190626131902.6xat2ab65arc62td@brauner.io> <156138532485.25627.7459410522109581052.stgit@warthog.procyon.org.uk> <20190626100525.irdehd24jowz5f75@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190626131902.6xat2ab65arc62td@brauner.io>
Content-ID: <9359.1561559497.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, raven@themaw.net, mszeredi@redhat.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Christian Brauner <christian@brauner.io> wrote:

> And I also very much recommend to remove any potential cross-dependency
> between the fsinfo() and the notification patchset.

The problem with that is that to make the notification patchset useful for
mount notifications, you need some information that you would obtain through
fsinfo().

David
