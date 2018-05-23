From: Davidlohr Bueso <dave@stgolabs.net>
Subject: semantics of rhashtable and sysvipc
Date: Wed, 23 May 2018 10:25:00 -0700
Message-ID: <20180523172500.anfvmjtumww65ief@linux-n805>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: manfred@colorfullife.com, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi,

In sysvipc we have an ids->tables_initialized regarding the rhashtable,
introduced in 0cfb6aee70b (ipc: optimize semget/shmget/msgget for lots of keys).
It's there, specifically, to prevent nil pointer dereferences, from using an
uninitialized api. Considering how rhashtable_init() can fail (probably due to
ENOMEM, if anything), this made the overall ipc initialization capable of
failure as well. That alone is ugly, but fine, however I've spotted a few
issues regarding the semantics of tables_initialized (however unlikely they
may be):

- There is inconsistency in what we return to userspace: ipc_addid() returns
ENOSPC which is certainly _wrong_, while ipc_obtain_object_idr() returns
EINVAL.

- After we started using rhashtables, ipc_findkey() can return nil upon
!tables_initialized, but the caller expects nil for when the ipc structure
isn't found, and can therefore call into ipcget() callbacks.

I see two possible fixes. The first is to return the proper error code
if !tables_initialized, however, I'm not sure how we want to deal with the
EINVAL cases when rhashtable_init() fails. Userspace has no reason to know
about this. The ENOMEM case I guess makes sense ok.

The second alternative would be to add a BUG_ON() if the initialization fails
and we get rid of all the tables_initialized hack. I know Linus isn't fond
of this, and in the past ipc has gotten rid of BUG_ON usage in ipc because
of this. However I mention it because there are other core areas that do this
(or call panic() straightaway). Ie in networking: sock_diag_init() and
netlink_proto_init().

Thoughts?

Thanks,
Davidlohr
