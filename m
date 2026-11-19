Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795086245;
	b=dfmAoip7q5tqz442yNaDFcUPmwCvknoxyCXDTq93mqitTird0YxJqEoxQsBLQhXPEU5B
	 qDqpHrhGJcRSGbE/wG7U6d4keBL3o+sqOg4L2d7NhWx73j5MX5hBEDWb227JUSKh1lObV
	 kyqFIW6GmrUjoVijr7IpkkjJOt2XJQHQbgXCacOkiNF1WGsjOywqt6RpyNFMqh6AvzB4B
	 rDn15GNGL7/Tqh/jkZ3LO/iiGWTQmHj5YkfZyZ+M+c2PkeTPdt2NWjRtPcRdOlNau23kH
	 /RadukyacJIZPDnizHYgc4DOcDWoPxs9G9m1E0qGloOU0yreqPHRw6tlDc+5k7O5S/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795086245;
	h=Received:DKIM-Signature:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:References:
	 Date:Message-Id:X-Mailer;
	bh=+E60zXbU4oZy8RU/l5/D1E6F0ffRVJUETCZ7wv1F10Y=;
	b=aobexIagumAqRFbSlp3Zn8rmnBhlvFDdNTJkoSoJ7zuuiV9ObuI9cW2Rpft8l3efsnLV
	 JJNaDhs0RoFHvirApjzCm8hBFfSoXITLchWUt2hQyI6fsod/C8uyBDyr4RNzE8u3cbwqt
	 ekbQ3ydxedAaht1zOdur3rFylwbSyAOYy9InTT0/5OApGo6qNFxSra498TDRCMsB753hQ
	 aWdTmI6UAH71vS9YeE1mxohx6iAP2DSVLdQTvVoQw0jgD+kS9q9Qz9mJXBXCf4H4r3gAT
	 x0tyTRwAJzOpYcyaMnCr9K6m807RulwSbJJqzrrzyUCiILKLJt59b+tRHGU3VaxbnOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iZf3M2id;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40573606A336;
	Thu, 19 Nov 2026 11:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iZf3M2id
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6501F000C7;
	Thu, 19 Nov 2026 11:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795086244;
	bh=+E60zXbU4oZy8RU/l5/D1E6F0ffRVJUETCZ7wv1F10Y=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=iZf3M2iddgqXAWp5PVcDNrzgtm00kzCg06gw8t+TeOb1CTN+vP3Dm6wrJHlX/lBSC
	 gfE9WusKIiVvR1yelUFMEIBx5rIngYtV7aQTWMJMVGF40lG6LoaYU5dhlHK+zgr6Gy
	 rRm7vu9AEAowDAmLsFbPia/q5iYbL71Apw9VFRs1AXor0RqV7EOcPmr8oJxfmqcZv+
	 63cOOoImihCw1bgSW3VoaUyGzqHdY16Tfe08muqNcUQfvOwDt+39WCdfmCSws3hm2P
	 GmfzvD8aBf+7HLG298opziRGaMZ9S4xqYZyjjgiW+egzOg3f/463r3RBcis2WlA98M
	 ry/6gzUUN1eqA==
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 5/7] liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl
 to freeze sessions early
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
 skhan@linuxfoundation.org, linux-doc@vger.kernel.org, vipinsh@google.com, 
 linux-kernel@vger.kernel.org, corbet@lwn.net, linux-api@vger.kernel.org, 
 dmatlack@google.com, kexec@lists.infradead.org, pratyush@kernel.org, 
 rdunlap@infradead.org, graf@amazon.com
In-Reply-To: <20261118212845.2855249-6-pasha.tatashin@soleen.com>
References: <20261118212845.2855249-1-pasha.tatashin@soleen.com>
 <20261118212845.2855249-6-pasha.tatashin@soleen.com>
Date: Thu, 19 Nov 2026 13:03:49 +0200
Message-Id: <179508622989.425130.16923155682094971634.b4-review@b4>
X-Mailer: b4 0.16.1-dev

Hi,

> Add the LIVEUPDATE_SESSION_FREEZE ioctl on outgoing session FDs. Once
> frozen, no additional files can be preserved in the session and
> repeated freeze calls return -EBUSY.
> 
> Currently, LUO freezes sessions only during reboot(LINUX_REBOOT_CMD_KEXEC),
> serially under global write locks. On hosts running multiple workloads
> such as VMs, freezing sessions early under their per-session mutexes
> lets workloads freeze in parallel as they pause ahead of kexec,
> reducing blackout time.
> 
> By default, session lifetime remains tied to the session FD: closing
> the FD before reboot unfreezes and unpreserves the session, while
> keeping it open skips late auto-freeze at kexec.
> 
> Add optional flag LIVEUPDATE_SESSION_FREEZE_COMMIT to serialize the
> frozen session and its FLBs immediately and transfer ownership to LUO
> until reboot. Committed sessions survive closing the session FD,
> allowing processes to hand off preserved state and exit prior to kexec.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  Documentation/userspace-api/liveupdate.rst | 20 ++++++
>  include/linux/liveupdate.h                 |  2 +-
>  include/uapi/linux/liveupdate.h            | 38 ++++++++++++
>  kernel/liveupdate/luo_file.c               | 37 +++++------
>  kernel/liveupdate/luo_internal.h           |  3 +
>  kernel/liveupdate/luo_session.c            | 71 ++++++++++++++++++++--
>  6 files changed, 146 insertions(+), 25 deletions(-)
>
> diff --git a/Documentation/userspace-api/liveupdate.rst b/Documentation/userspace-api/liveupdate.rst
> index cdd74627ab75b..c298b5d0dfe75 100644
> --- a/Documentation/userspace-api/liveupdate.rst
> +++ b/Documentation/userspace-api/liveupdate.rst
> @@ -22,6 +22,26 @@ change, so compatibility is not guaranteed when kexec rebooting between
>  different kernel versions. This is expected to change and stabilize in a future
>  version.
>  
> +Session Freeze
> +==============
> +
> +By default, LUO freezes active sessions during reboot, and an outgoing session
> +stays alive only while its session fd remains open. Closing the fd before
> +reboot aborts preservation and releases the session's resources.
> +
> +Userspace can freeze an outgoing session earlier with LIVEUPDATE_SESSION_FREEZE
> +once it is done preserving and modifying the session's files:
> +
> +- Freeze: freezes the session's preserved files, allowing sessions to freeze
> +  concurrently ahead of reboot. The session remains tied to its fd, so closing
> +  the fd before reboot rolls back and releases the session.
> +
> +- Freeze and commit: userspace can optionally set
> +  LIVEUPDATE_SESSION_FREEZE_COMMIT in flags to commit the frozen session. This
> +  serializes the session and its FLBs into the outgoing KHO state immediately
> +  and hands ownership to LUO. Once committed, the session survives closing its
> +  fd until reboot, allowing processes to exit before kexec.
> +
>  Userspace Integration
>  =====================
>  
> diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
> index 6051abc0612ce..ead033c59c22d 100644
> --- a/include/linux/liveupdate.h
> +++ b/include/linux/liveupdate.h
> @@ -59,7 +59,7 @@ struct liveupdate_file_op_args {
>   *                compatible with the given file.
>   * @preserve:     Required. Performs state-saving for the file.
>   * @unpreserve:   Required. Cleans up any resources allocated by @preserve.
> - * @freeze:       Optional. Final actions just before kernel transition.
> + * @freeze:       Optional. Final actions on session freeze or reboot.
>   * @unfreeze:     Optional. Undo freeze operations.
>   * @retrieve:     Required. Restores the file in the new kernel.
>   * @can_finish:   Optional. Check if this FD can finish, i.e. all restoration
> diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
> index 4043d40387125..ac456f4014c5d 100644
> --- a/include/uapi/linux/liveupdate.h
> +++ b/include/uapi/linux/liveupdate.h
> @@ -60,6 +60,7 @@ enum {
>  	LIVEUPDATE_CMD_SESSION_RETRIEVE_FD = 0x41,
>  	LIVEUPDATE_CMD_SESSION_FINISH = 0x42,
>  	LIVEUPDATE_CMD_SESSION_GET_NAME = 0x43,
> +	LIVEUPDATE_CMD_SESSION_FREEZE = 0x44,
>  };
>  
>  /**
> @@ -236,4 +237,41 @@ struct liveupdate_session_get_name {
>  #define LIVEUPDATE_SESSION_GET_NAME					\
>  	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_GET_NAME)
>  
> +/**
> + * enum liveupdate_session_freeze_flags - Flags for LIVEUPDATE_SESSION_FREEZE
> + * @LIVEUPDATE_SESSION_FREEZE_COMMIT: Commit the frozen session so it is
> + *                                    serialized immediately and survives
> + *                                    closing the session FD until reboot.
> + */
> +enum liveupdate_session_freeze_flags {
> +	LIVEUPDATE_SESSION_FREEZE_COMMIT = 1 << 0,
> +};
> +
> +/**
> + * struct liveupdate_session_freeze - ioctl(LIVEUPDATE_SESSION_FREEZE)
> + * @size:  Input; sizeof(struct liveupdate_session_freeze)
> + * @flags: Input; Bitmask of enum liveupdate_session_freeze_flags.
> + *
> + * Freezes an outgoing session before kexec reboot. Once frozen, no further
> + * files can be preserved in the session and repeated freeze calls return
> + * -EBUSY. Calling this on an incoming session returns -EINVAL.
> + *
> + * With @flags set to 0, session lifetime stays tied to the session FD:
> + * closing the FD before reboot unfreezes and unpreserves the session.
> + *
> + * With %LIVEUPDATE_SESSION_FREEZE_COMMIT set, the frozen session is
> + * serialized immediately and ownership transfers to LUO until reboot.
> + * Closing the FD or another session failing to freeze during reboot will
> + * not unfreeze or unpreserve a committed session.

Once a session is committed and its fd is closed, there's no way back. The
memory stays preserved, the name returns -EEXIST, and if the update is
aborted the session will be handed over on whatever next kexec happens.

How is userspace expected to recover from an aborted live update after it
committed some sessions? Should there be a way to reclaim or discard a
committed session, e.g. by reopening it by name or by a separate command?

> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +struct liveupdate_session_freeze {
> +	__u32		size;
> +	__u32		flags;
> +};
> +
> +#define LIVEUPDATE_SESSION_FREEZE					\
> +	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_FREEZE)
> +
>  #endif /* _UAPI_LIVEUPDATE_H */
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index cdd3c466e5ac3..2cbac44d37cce 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -31,9 +31,8 @@
>   *   - unpreserve(): Cleans up any resources allocated by .preserve(), called
>   *     if the preservation process is aborted before the reboot (i.e. session is
>   *     closed).
> - *   - freeze(): A final pre-reboot opportunity to prepare the state for kexec.
> - *     We are already in reboot syscall, and therefore userspace cannot mutate
> - *     the file anymore.
> + *   - freeze(): Prepares the final state for kexec, invoked either on an

GitHub Copilot <copilot@localhost>:

The removed sentence was the only place documenting what .freeze() may
assume. With early freeze userspace still has the files and can keep using
them after freeze returns. For example, memfd_luo_freeze() snapshots f_pos,
and the memfd documentation says the current file position is preserved,
which is no longer true if the file is used after the freeze.

memfd is fine otherwise because size and folios are pinned at preserve time,
but please spell out in the liveupdate_file_ops kernel-doc that a file may
be accessed after .freeze() and that handlers must not rely on it being
quiescent.

> + *     explicit session freeze or during the reboot() syscall.
>   *   - unfreeze(): Undoes the actions of .freeze(), called if the live update
>   *     is aborted after the freeze phase.
>   *   - retrieve(): Reconstructs the file in the new kernel from the preserved
> @@ -48,7 +47,7 @@
>   *    handler, calls its .preserve() operation, and creates an internal &struct
>   *    luo_file to track the live state.
>   *
> - * 2. Freeze (Pre-Reboot): Just before the kexec, luo_file_freeze() is called.
> + * 2. Freeze (Pre-Reboot): When a session freezes, luo_file_freeze() is called.
>   *    It iterates through all preserved files, calls their respective .freeze()
>   *    operation, and serializes their final metadata (compatible string, token,
>   *    and data handle) into a contiguous memory block for KHO.
> @@ -77,12 +76,15 @@
>   *    descriptor), the session's release handler calls
>   *    luo_file_unpreserve_files(). This invokes the .unpreserve() callback on
>   *    all preserved files, ensuring all allocated resources are cleaned up and
> - *    returning the system to a clean state.
> + *    returning the system to a clean state. If the session was frozen early
> + *    without committing, its files are unfrozen first. Committed sessions stay
> + *    preserved until reboot even after the session FD is closed.
>   *
>   * 2. Freeze Failure: During the reboot() syscall, if any handler's .freeze()
>   *    op fails, the .unfreeze() op is invoked on all previously *successful*
>   *    freezes to roll back their state. The reboot() syscall then returns an
> - *    error to userspace, canceling the live update.
> + *    error to userspace, canceling the live update. On an explicit session
> + *    freeze, only that session's frozen files are rolled back via .unfreeze().
>   *
>   * 3. Finish Failure: In the new kernel, if a handler's .finish() op fails,
>   *    the luo_file_finish() operation is aborted. LUO retains ownership of
> @@ -457,9 +459,9 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
>   * luo_file_freeze - Freezes all preserved files and serializes their metadata.
>   * @file_set: The file_set whose files are to be frozen.
>   *
> - * This function is called from the reboot() syscall path, just before the
> - * kernel transitions to the new image via kexec. Its purpose is to perform the
> - * final preparation and serialization of all preserved files in the file_set.
> + * This function is called on explicit session freeze or from the reboot()
> + * syscall path to perform final preparation and serialization of all
> + * preserved files in the file_set.
>   *
>   * It iterates through each preserved file in FIFO order (the order of
>   * preservation) and performs two main actions:
> @@ -476,13 +478,12 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
>   *
>   * Error Handling (Rollback):
>   * This function is atomic. If any handler's .freeze() operation fails, the
> - * entire live update is aborted. The __luo_file_unfreeze() helper is
> - * immediately called to invoke the .unfreeze() op on all files that were
> - * successfully frozen before the point of failure, rolling them back to a
> - * running state. The function then returns an error, causing the reboot()
> - * syscall to fail.
> + * __luo_file_unfreeze() helper is immediately called to invoke the .unfreeze()
> + * op on all files that were successfully frozen before the point of failure,
> + * rolling them back to an unfrozen state, and an error is returned to the
> + * caller, canceling the live update if called from the reboot() path.
>   *
> - * Context: Called only from the liveupdate_reboot() path.
> + * Context: Called on explicit session freeze or from liveupdate_reboot().
>   * Return: 0 on success, or a negative errno on failure.
>   */
>  int luo_file_freeze(struct luo_file_set *file_set)
> @@ -532,15 +533,15 @@ int luo_file_freeze(struct luo_file_set *file_set)
>   * @file_set: The file_set whose files are to be unfrozen.
>   *
>   * This function rolls back the state of all files in a file_set after the
> - * freeze phase has begun but must be aborted. It is the counterpart to
> - * luo_file_freeze().
> + * freeze phase has begun. It is the counterpart to luo_file_freeze().
>   *
>   * It invokes the __luo_file_unfreeze() helper with a NULL argument, which
>   * signals the helper to iterate through all files in the file_set, call their
>   * respective .unfreeze() handler callbacks, and clear the serialized blocks.
>   *
>   * Context: This is called when the live update is aborted during
> - *          the reboot() syscall, after luo_file_freeze() has been called.
> + *          the reboot() syscall, after luo_file_freeze() has been called,
> + *          or when a frozen uncommitted session is released before kexec.
>   */
>  void luo_file_unfreeze(struct luo_file_set *file_set)
>  {
> diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
> index 3d948279f018c..bd3f0d1926218 100644
> --- a/kernel/liveupdate/luo_internal.h
> +++ b/kernel/liveupdate/luo_internal.h
> @@ -66,6 +66,8 @@ struct luo_file_set {
>   *              retrieved by a consumer in the new kernel.
>   * @serialized: A boolean flag indicating whether this outgoing session has
>   *              been serialized into KHO.
> + * @user_frozen: A boolean flag indicating whether this session has been
> + *               frozen explicitly from userspace.
>   * @file_set:   A set of files that belong to this session.
>   * @mutex:      protects fields in the luo_session.
>   */
> @@ -74,6 +76,7 @@ struct luo_session {
>  	struct list_head list;
>  	bool retrieved;
>  	bool serialized;
> +	bool user_frozen;
>  	struct luo_file_set file_set;
>  	struct mutex mutex;
>  };
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> index 013386534b698..bf58718fa61ba 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -34,10 +34,11 @@
>   * 1.  Creation: A userspace agent calls `luo_session_create()` to create a
>   *     new, empty session and receives a file descriptor for it.
>   *
> - * 2.  Serialization: When the `reboot(LINUX_REBOOT_CMD_KEXEC)` syscall is
> - *     made, `luo_session_serialize()` is called. It iterates through all
> - *     active sessions and writes their metadata into a memory area preserved
> - *     by KHO.
> + * 2.  Serialization: Sessions may be frozen ahead of reboot via
> + *     `LIVEUPDATE_SESSION_FREEZE`, and optionally committed to serialize
> + *     their metadata into KHO immediately so they survive closing the FD.
> + *     When `reboot(LINUX_REBOOT_CMD_KEXEC)` is called,
> + *     `luo_session_serialize()` freezes and serializes any remaining sessions.
>   *
>   * 3.  Deserialization (in new kernel): After kexec, `luo_session_deserialize()`
>   *     runs, reading the serialized data and creating a list of `struct
> @@ -254,12 +255,21 @@ static int luo_session_finish_one(struct luo_session *session)
>  static void luo_session_unfreeze_one(struct luo_session *session)
>  {
>  	guard(mutex)(&session->mutex);
> -	luo_file_unfreeze(&session->file_set);
> +	/*
> +	 * Only unfreeze sessions that were auto-frozen by
> +	 * luo_session_freeze_one(); sessions frozen explicitly by
> +	 * userspace stay frozen until the session FD is closed.
> +	 */
> +	if (!session->user_frozen)
> +		luo_file_unfreeze(&session->file_set);
>  }
>  
>  static int luo_session_freeze_one(struct luo_session *session)
>  {
>  	guard(mutex)(&session->mutex);
> +	if (session->user_frozen)
> +		return 0;
> +
>  	return luo_file_freeze(&session->file_set);
>  }
>  
> @@ -280,8 +290,13 @@ static int luo_session_release(struct inode *inodep, struct file *filep)
>  		}
>  		sh = &luo_session_global.incoming;
>  	} else {
> -		scoped_guard(mutex, &session->mutex)
> +		scoped_guard(mutex, &session->mutex) {
> +			if (session->serialized)
> +				return 0;
> +			if (session->user_frozen)
> +				luo_file_unfreeze(&session->file_set);
>  			luo_file_unpreserve_files(&session->file_set);
> +		}
>  		sh = &luo_session_global.outgoing;
>  	}
>  
> @@ -298,6 +313,9 @@ static int luo_session_preserve_fd(struct luo_session *session,
>  	int err;
>  
>  	guard(mutex)(&session->mutex);
> +	if (session->user_frozen)
> +		return -EBUSY;
> +
>  	err = luo_preserve_file(&session->file_set, argp->token, argp->fd);
>  	if (err)
>  		return err;
> @@ -371,11 +389,50 @@ static int luo_session_get_name(struct luo_session *session,
>  	return luo_ucmd_respond(ucmd, sizeof(*argp));
>  }
>  
> +static int luo_session_freeze(struct luo_session *session,
> +			      struct luo_ucmd *ucmd)
> +{
> +	struct liveupdate_session_freeze *argp = ucmd->cmd;
> +	int err;
> +
> +	if (argp->flags & ~LIVEUPDATE_SESSION_FREEZE_COMMIT)
> +		return -EOPNOTSUPP;
> +
> +	scoped_guard(mutex, &session->mutex) {
> +		if (session->user_frozen)
> +			return -EBUSY;

This means that a session frozen without COMMIT can never be committed. A
VMM that freezes early to shorten the blackout time has to decide right
then whether the session is handed off.

Can we allow COMMIT on a session that is user_frozen but not yet
serialized? That would let userspace freeze early and commit later, which
looks like a more natural flow.

> +
> +		err = luo_file_freeze(&session->file_set);
> +		if (err)
> +			return err;
> +
> +		err = luo_ucmd_respond(ucmd, sizeof(*argp));
> +		if (err) {
> +			luo_file_unfreeze(&session->file_set);
> +			return err;
> +		}
> +
> +		session->user_frozen = true;
> +	}
> +
> +	if (argp->flags & LIVEUPDATE_SESSION_FREEZE_COMMIT) {
> +		struct luo_session_header *sh = &luo_session_global.outgoing;
> +
> +		guard(rwsem_write)(&sh->rwsem);
> +		guard(mutex)(&session->mutex);
> +
> +		luo_session_serialize_one(session);

The response is already copied to userspace above and
luo_session_serialize_one() returns void, so if it fails the ioctl still
reports success. 

AFAIU the failure there is a WARN that shouldn't happen because the
capacity is reserved in sh->count, so this is minor, but having
luo_session_serialize_one() return an error and responding after the
commit would be cleaner.

-- 
Sincerely yours,
Mike.

