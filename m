From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 09/25] vfs: Allow mount information to be queried by fsinfo() [ver #13]
Date: Tue, 18 Jun 2019 15:00:30 +0100
Message-ID: <18849.1560866430@warthog.procyon.org.uk>
References: <20190601160822.GA77761@google.com> <155905626142.1662.18430571708534506785.stgit@warthog.procyon.org.uk> <155905633578.1662.8087594848892366318.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190601160822.GA77761@google.com>
Content-ID: <18753.1560866343.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Joel Fernandes <joel@joelfernandes.org>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, raven@themaw.net, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-api@vger.kernel.org

Joel Fernandes <joel@joelfernandes.org> wrote:

> > +	record.mnt_id = m->mnt_id;
> > +	record.notify_counter = atomic_read(&m->mnt_notify_counter);
> > +	store_mount_fsinfo(params, &record);
> > +
> > +	rcu_read_unlock();
> 
> Not super familiar with this code, but wanted to check with you:
> 
> Here, if the rcu_read_lock is supposed to protect the RCU list, can
> rcu_read_lock() scope be reduced to just wrapping around the
> list_for_each_entry_rcu?

Done.

David
