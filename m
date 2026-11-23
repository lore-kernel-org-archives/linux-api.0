Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442763;
	b=HteVB1HhEutf87ilxpD5kpg5PuC/OE7/9Yf2TnACs95+KhJggJz6I6Q47tRnUAmcejvx
	 wRyEmFweEh6uCMHabSaf8LYSipq8R2Rj+HMFzlRyojM1gjl+DlRpjtFGA51utvWFmbNFu
	 wn4Il1WFxKA/GDkxaBGNILnoH6hjLuKCZzc0cYi9e6fOreuOmKXAFQMLHLa/8K7me4WfL
	 IorkaSKlpHZ6zOLT3JenhxXieB9iQ4rxREesa0vy67lGYV53BUAGka7NOF7AYQBMlzfRy
	 /lqJLD7xwmdPtPm+OfjOlHPslFJ8OH/Vz+E4Ds5sljTybXhjWY3TwrYSilcSB+LUhmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442763;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ZhrfZY0fbfvRqh4m81PmC72i9FRlptZs7yDrySCwPr4=;
	b=SYtFgVqelkAzocufmb4qojWHGB8xkuvXRGmKrM6PPGSK35VaDLCnoDSC4QGgt/nek7/o
	 qHfjOlW2H+PscwYdVzezYjdNvL6Wrua5wLeyl46JTlzhYzr1ZlxZmeZBr+P9moG0aaGqq
	 qlMLfhWNTEb1Z+pSrQtBsHud9zP+ylMlZk6sJaIDJEAL5aUCXGxi11jsGfrWQ0yc07bii
	 kP4T505oFx8IotoZgBUQUf+dYi29rZh5N9tJGFNgdK2ktGtFYhTuiFyL/wGn7ARAtcAEp
	 CpdMGqbIdyHwj3yRub7uzfaoxVlpz7+vBtbwmPuZSQKAfrQGMRaUihRenvFomFD3Hrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RNxcIodY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id F0193606A32A;
	Mon, 23 Nov 2026 14:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RNxcIodY
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D36961F000CF;
	Mon, 23 Nov 2026 14:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795442762;
	bh=ZhrfZY0fbfvRqh4m81PmC72i9FRlptZs7yDrySCwPr4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RNxcIodYicyykOWzJV9ac41R/wLtMtTMT0f/m7QOJ6ld+W2V4NCjmrvht5+ezWSqk
	 Dy3cclszSYRA92VabFyR/cC0uPGOyYPHssIDBCdfY+KgqULwwUey6pUnHB73Wz2LlR
	 hkvMBoXjf7CrpiBPOawkWFvKWPg3qpI0I0BA69XEEhog6RMMjCMYfTFgbRasThroj3
	 3VZZgT2wtToaSR3IXgQGEzMZxs3Ms6FWViRaFd9Loduz7vVzijOuh6nSFxj66HY9ck
	 NEhojYrvdZmhi6MyoIHwjX3SFqytTuELhGvYjoQLWNYl5Hp0HF12MLor0raNKqJDPd
	 nl02fB8BrjaLw==
Date: Mon, 23 Nov 2026 16:05:58 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: bot+bpf-ci@kernel.org
Cc: linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
	containers@lists.linux.dev, linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	aleksa@amutable.com, alex@amutable.com, viro@zeniv.linux.org.uk,
	luto@amacapital.net, arnd@arndb.de, brauner@kernel.org,
	dhowells@redhat.com, ebiggers@kernel.org, giuseppe@scrivano.org,
	hughd@google.com, jack@suse.cz, jlayton@kernel.org, corbet@lwn.net,
	josef@toxicpanda.com, kees@kernel.org, kpsingh@kernel.org,
	lennart@poettering.net, neal@gompa.dev, oleg@redhat.com,
	paul@paul-moore.com, ptikhomirov@virtuozzo.com, sergeh@kernel.org,
	skhan@linuxfoundation.org, zygmunt.krynicki@canonical.com,
	ast@kernel.org, andrii@kernel.org, daniel@iogearbox.net,
	martin.lau@kernel.org, eddyz87@gmail.com, yonghong.song@linux.dev,
	mason@kernel.org, ihor.solodrai@linux.dev
Subject: Re: [RFC PATCH v7 07/26] mount: Support MOVE_MOUNT_CLONE with
 MOVE_MOUNT_T_MNTNS
Message-ID: <awRIRrGwOi97H15D@kernel.org>
References: <20261122193539.3334213-8-jarkko@kernel.org>
 <cac1fa0b133e15e7c67629319df17a0d25747093535aa246f44a75cb1073e2ed@mail.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cac1fa0b133e15e7c67629319df17a0d25747093535aa246f44a75cb1073e2ed@mail.kernel.org>

On Sun, Nov 22, 2026 at 08:28:11PM +0000, bot+bpf-ci@kernel.org wrote:
> Should the clone be reported to LSMs as a bind, for example through a
> separate hook, a flag passed to security_move_mount(), or a call to the
> bind-mount mediation?

Mediation can be trivially achieved:

diff --git a/security/apparmor/include/mount.h b/security/apparmor/include/mount.h
index 46834f828179..d771ee240d42 100644
--- a/security/apparmor/include/mount.h
+++ b/security/apparmor/include/mount.h
@@ -43,7 +43,7 @@ int aa_move_mount_old(const struct cred *subj_cred,
                      const char *old_name);
 int aa_move_mount(const struct cred *subj_cred,
                  struct aa_label *label, const struct path *from_path,
-                 const struct path *to_path);
+                 const struct path *to_path, unsigned int flags);

 int aa_new_mount(const struct cred *subj_cred,
                 struct aa_label *label, const char *dev_name,
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index aefa71bc1cd2..797944de8273 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -751,7 +751,7 @@ static int apparmor_move_mount(const struct path *from_path,
        label = __begin_current_label_crit_section(&needput);
        if (!unconfined(label))
                error = aa_move_mount(current_cred(), label, from_path,
-                                     to_path);
+                                     to_path, flags);
        __end_current_label_crit_section(label, needput);

        return error;
diff --git a/security/apparmor/mount.c b/security/apparmor/mount.c
index 4ed7b9136beb..8d3db6bfdfb6 100644
--- a/security/apparmor/mount.c
+++ b/security/apparmor/mount.c
@@ -423,13 +423,15 @@ int aa_mount_change_type(const struct cred *subj_cred,

 int aa_move_mount(const struct cred *subj_cred,
                  struct aa_label *label, const struct path *from_path,
-                 const struct path *to_path)
+                 const struct path *to_path, unsigned int flags)
 {
        struct aa_profile *profile;
        char *to_buffer = NULL, *from_buffer = NULL;
+       unsigned long mnt_flags = (flags & MOVE_MOUNT_CLONE) ?
+                                 (MS_BIND | MS_REC) : MS_MOVE;
        int error;
        DEFINE_AUDIT_MOUNT(ad, OP_MOUNT, subj_cred);
-       ad.mnt.flags = MS_MOVE;
+       ad.mnt.flags = mnt_flags;

        AA_BUG(!label);
        AA_BUG(!from_path);
@@ -441,12 +443,12 @@ int aa_move_mount(const struct cred *subj_cred,
        if (!to_buffer || !from_buffer)
                goto out;

-       if (!our_mnt(from_path->mnt))
+       if (!(flags & MOVE_MOUNT_CLONE) && !our_mnt(from_path->mnt))
                /* moving a mount detached from the namespace */
                from_path = NULL;
        error = fn_for_each(label, profile,
                        match_mnt(profile, to_path, to_buffer, from_path,
-                                 from_buffer, NULL, MS_MOVE, NULL, false,
+                                 from_buffer, NULL, mnt_flags, NULL, false,
                                  &ad));
 out:
        aa_put_buffer(to_buffer);
@@ -467,7 +469,7 @@ int aa_move_mount_old(const struct cred *subj_cred, struct aa_label *label,
        if (error)
                return error;

-       error = aa_move_mount(subj_cred, label, &old_path, path);
+       error = aa_move_mount(subj_cred, label, &old_path, path, 0);
        path_put(&old_path);

        return error;

Br, Jarkko
