From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC][PATCH] ipc: Remove IPCMNI
Date: Thu, 29 Mar 2018 15:08:01 -0500
Message-ID: <87y3ia3ase.fsf@xmission.com>
References: <1520885744-1546-1-git-send-email-longman@redhat.com>
        <1520885744-1546-5-git-send-email-longman@redhat.com>
        <87woyfyh57.fsf@xmission.com>
        <5d4a858a-3136-5ef4-76fe-a61e7f2aed56@redhat.com>
        <87o9jru3bf.fsf@xmission.com>
        <935a7c50-50cc-2dc0-33bb-92c000d039bc@redhat.com>
        <87woyego2u.fsf_-_@xmission.com>
        <047c6ed6-6581-b543-ba3d-cadc543d3d25@redhat.com>
        <87h8ph6u67.fsf@xmission.com>
        <7d3a1f93-f8e5-5325-f9a7-0079f7777b6f@redhat.com>
        <20180329021409.gcjjrmviw2lckbfk@linux-n805>
        <3e201de2-bed2-6f7d-0783-700d095142e0@colorfullife.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3e201de2-bed2-6f7d-0783-700d095142e0@colorfullife.com> (Manfred
        Spraul's message of "Thu, 29 Mar 2018 10:47:45 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>, Waiman Long <longman@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, Stanislav Kinsbursky <skinsbursky@parallels.com>, Linux Containers <containers@lists.linux-foundation.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Manfred Spraul <manfred@colorfullife.com> writes:

>>>>> On 03/14/2018 08:49 PM, Eric W. Biederman wrote:
>>>>>> To make it possible to keep checkpoint/restore working I have renamed
>>>>>> the sysctls from xxx_next_id to xxx_nextid.  That is enough change that
>>>>>> a smart CRIU implementation can see that what is exported has changed,
>>>>>> and act accordingly.  New kernels will be able to restore the old id's.
>>>>>>
>>>>>> This code still needs some real world testing to verify my assumptions.
>>>>>> And some work with the CRIU implementations to actually add the code
>>>>>> that deals with the new for of id assignment.
>>>>>>
> It means that all existing checkpoint/restore application will not work with a
> new kernel.
> Everyone must first update the checkpoint/restore application, then update the
> kernel.
>
> Is this acceptable?

There is no nead.

I just reread through how next_id is implementated in ipc/util.c and I
had been reading it wrong.  There is no need to change the sysctl.

What criu needs is an interface that specifies the next_id to allocate
both the high and the low bits and that is what this the sysctl
provides.

The implemenation could use a little cleanup so it is easier to
understand something like this perhaps:

diff --git a/ipc/util.c b/ipc/util.c
index 3783b7991cc7..2d4ec6e5b70b 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -192,46 +192,32 @@ static struct kern_ipc_perm *ipc_findkey(struct ipc_ids *ids, key_t key)
 	return NULL;
 }
 
-#ifdef CONFIG_CHECKPOINT_RESTORE
-/*
- * Specify desired id for next allocated IPC object.
- */
-#define ipc_idr_alloc(ids, new)						\
-	idr_alloc(&(ids)->ipcs_idr, (new),				\
-		  (ids)->next_id < 0 ? 0 : ipcid_to_idx((ids)->next_id),\
-		  0, GFP_NOWAIT)
-
-static inline int ipc_buildid(int id, struct ipc_ids *ids,
-			      struct kern_ipc_perm *new)
-{
-	if (ids->next_id < 0) { /* default, behave as !CHECKPOINT_RESTORE */
-		new->seq = ids->seq++;
-		if (ids->seq > IPCID_SEQ_MAX)
-			ids->seq = 0;
-	} else {
-		new->seq = ipcid_to_seqx(ids->next_id);
-		ids->next_id = -1;
-	}
 
-	return SEQ_MULTIPLIER * new->seq + id;
-}
-
-#else
-#define ipc_idr_alloc(ids, new)					\
-	idr_alloc(&(ids)->ipcs_idr, (new), 0, 0, GFP_NOWAIT)
-
-static inline int ipc_buildid(int id, struct ipc_ids *ids,
-			      struct kern_ipc_perm *new)
+static inline int ipc_idr_alloc(struct ipc_ids *ids, struct kern_ipc_perm *new)
 {
+	int id;
+#ifdef CONFIG_CHECKPOINT_RESTORE
+	if (unlikely(new->id >= 0)) {
+		int idx = ipcid_to_idx(new->id);
+		id = idr_alloc(&ids->ipcs_idr, new, idx, 0, GFP_NOWAIT);
+		if (id < 0)
+			return id;
+		if (id != idx) {
+			idr_remove(&ids->ipcs_idr, id);
+			return -EBUSY;
+		}
+		new->seq = ipcid_to_seqx(new->id);
+		return id;
+	}
+#endif
+	id = idr_alloc(&ids->ipcs_idr, new, 0, 0, GFP_NOWAIT);
 	new->seq = ids->seq++;
 	if (ids->seq > IPCID_SEQ_MAX)
 		ids->seq = 0;
-
-	return SEQ_MULTIPLIER * new->seq + id;
+	new->id = SEQ_MULTIPLIER * new->seq + id;
+	return id;
 }
 
-#endif /* CONFIG_CHECKPOINT_RESTORE */
-
 /**
  * ipc_addid - add an ipc identifier
  * @ids: ipc identifier set
@@ -269,6 +255,10 @@ int ipc_addid(struct ipc_ids *ids, struct kern_ipc_perm *new, int limit)
 	new->cuid = new->uid = euid;
 	new->gid = new->cgid = egid;
 
+	new->id = ids->next_id;
+	if (new->id >= 0)
+		ids->next_id = -1;
+
 	id = ipc_idr_alloc(ids, new);
 	idr_preload_end();
 
@@ -290,8 +280,6 @@ int ipc_addid(struct ipc_ids *ids, struct kern_ipc_perm *new, int limit)
 	if (id > ids->max_id)
 		ids->max_id = id;
 
-	new->id = ipc_buildid(id, ids, new);
-
 	return id;
 }
 

Eric
