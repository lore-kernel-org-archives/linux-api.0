Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2543442D76E;
	Thu, 16 Jul 2026 14:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212743; cv=pass; b=gG0rwYWOGucbBAC7z6sYeZSL2ukze/cHcuYRkL1/P7OvsNqmPuxrioootf3mlXVPhrQllwDV8XbljResT0D13pSheq8D+sb5d5YNOhN9c6GqGd7x4jXJq9vy854K7RbdR8q4yrVcdJvGcYY0fkOs9xcvTQPEld1eJNhaY8065GI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212743; c=relaxed/simple;
	bh=j1mYg0q8Co8Q3jEbGmyPo+OfltvFsrL8Js0To/6cJ0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcP/w5f8lOc2sYAem0kr65mB2CLFzPdawo/AFastdBh4cj7SHT6erbUJ0kMsxxc4aYlb3SfNqCUKcyddAFret7QO9TRbXvKhMtOZD3zD5bT8DdLVVDvl7jAKAR4T5u7LfxHqMQth6KrFntj9azl8HFvM4bsJVVPC2taJsmSrf7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=lGJLlnnk; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="lGJLlnnk"
ARC-Seal: i=1; a=rsa-sha256; t=1784212442; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=PcmXxNM116ujYktl2B8PgN5Fb2vWu5zbR65PNCo1Gh6e8D8pnRZrZp537ovK4kpVsSf0//E6UrJFBKhLNpewOAFmpRm1RIyMeXxCGpN1PTKlEhHwWQRfSL8McbjWzLbctXfmL6UMtn17Sqmd4roAONLPAxI3hw6hEm4FLg7LWW4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212442; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Ya4G86ANygOaWUOVa7w62N+5O+59ZsUYvR63syVDoH0=; 
	b=CXEujvq1A7pk+uPqgahtMdBLptpfgKaCrfdsnkslZr7dwacljmH+h14u/3urOldxAaMa+T4GweHy1IJM933Tx1ynElD0vsbCElctMURPoPeZB9fCApmtNFhdfYYr7z49XYgPUCFziO4qH0M7H7Lh7OFv6GdpkBzTx4SzqatPIjs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212442;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Ya4G86ANygOaWUOVa7w62N+5O+59ZsUYvR63syVDoH0=;
	b=lGJLlnnk1l68wegebseYTGhaS7a/4IJ25ceMPX+dWJlVkOqso7Y1M+m3r2v6nFt8
	7ozdGp3BAhINZmmHSuU/JjDrUEmoaNaSmqIWSKLBEUmFnmuyCeZXv4ULG03WxubL4uT
	wLphikbx40W26kFF/RoLofgQutFQUD45REflaRCA=
Received: by mx.zohomail.com with SMTPS id 1784212439389523.0177283934667;
	Thu, 16 Jul 2026 07:33:59 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Gabriel Krisman Bertazi <krisman@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	audit@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH 11/24] pidfd: add spawn builder state tracking
Date: Thu, 16 Jul 2026 22:31:37 +0800
Message-ID: <9f04647b62927055673942e0d4e1ef93fd4c41f3.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Add explicit configuring, starting, setup, started, and cancelled
states. Serialize configuration and launch transitions with the builder
mutex so configuration cannot change after task creation starts.

Publish the eventual pid with release and acquire ordering. This state
machine also provides the boundary for later one-shot claim and
cancellation semantics.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/pidfd_spawn.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/fs/pidfd_spawn.c b/fs/pidfd_spawn.c
index 46207c8e8139f..99e3ef56ecfa3 100644
--- a/fs/pidfd_spawn.c
+++ b/fs/pidfd_spawn.c
@@ -22,6 +22,14 @@
 
 #define PIDFD_SPAWN_MAX_CONFIG_KEY_SIZE	256
 
+enum pidfd_spawn_status {
+	PIDFD_SPAWN_CONFIGURING,
+	PIDFD_SPAWN_STARTING,
+	PIDFD_SPAWN_SETUP_DONE,
+	PIDFD_SPAWN_STARTED,
+	PIDFD_SPAWN_CANCELLED,
+};
+
 struct pidfd_spawn_state {
 	/* Serializes configuration and payload teardown. */
 	struct mutex lock;
@@ -31,10 +39,45 @@ struct pidfd_spawn_state {
 	const struct cred *creator_cred;
 	struct pid_namespace *creator_pid_ns;
 	char *staged_path;
+	enum pidfd_spawn_status status;
 };
 
+static struct pid *
+pidfd_spawn_load_pid(const struct pidfd_spawn_state *state)
+{
+	/* Pair with the release publication in pidfd_spawn_publish_pid(). */
+	return smp_load_acquire(&state->pid);
+}
+
+static enum pidfd_spawn_status
+pidfd_spawn_get_status(const struct pidfd_spawn_state *state)
+{
+	return READ_ONCE(state->status);
+}
+
+static void pidfd_spawn_set_status(struct pidfd_spawn_state *state,
+				   enum pidfd_spawn_status status)
+{
+	WRITE_ONCE(state->status, status);
+}
+
 static void pidfd_spawn_state_put(struct pidfd_spawn_state *state);
 
+static int
+pidfd_spawn_configuring_error(const struct pidfd_spawn_state *state)
+{
+	switch (pidfd_spawn_get_status(state)) {
+	case PIDFD_SPAWN_CONFIGURING:
+		return 0;
+	case PIDFD_SPAWN_CANCELLED:
+		if (!pidfd_spawn_load_pid(state))
+			return -ECANCELED;
+		fallthrough;
+	default:
+		return -EBUSY;
+	}
+}
+
 static void pidfd_spawn_free_state(struct pidfd_spawn_state *state)
 {
 	kfree(state->staged_path);
@@ -73,7 +116,7 @@ static struct pid *pidfd_spawn_file_pid(void *data)
 	struct pidfd_spawn_state *state = data;
 	struct pid *pid;
 
-	pid = READ_ONCE(state->pid);
+	pid = pidfd_spawn_load_pid(state);
 	return pid ? pid : ERR_PTR(-ESRCH);
 }
 
@@ -136,6 +179,10 @@ static int pidfd_spawn_state_set_path(struct pidfd_spawn_state *state,
 		return PTR_ERR(path);
 
 	scoped_cond_guard(mutex_intr, return -EINTR, &state->lock) {
+		int ret = pidfd_spawn_configuring_error(state);
+
+		if (ret)
+			return ret;
 		if (!pidfd_spawn_same_creator(state))
 			return -EPERM;
 
@@ -216,6 +263,7 @@ int pidfd_empty_open(unsigned int flags)
 	state->creator_cred = get_current_cred();
 	state->creator_pid_ns =
 		get_pid_ns(current->nsproxy->pid_ns_for_children);
+	pidfd_spawn_set_status(state, PIDFD_SPAWN_CONFIGURING);
 
 	pidfile = pidfs_alloc_future_file("[pidfd_spawn]", state,
 					  &pidfd_spawn_future_ops,
-- 
2.52.0

