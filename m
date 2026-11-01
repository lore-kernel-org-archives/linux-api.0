Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793498242;
	b=0XxO5lB48BrVdYnHzW0kN7/7O6+deVt5g/lSJpIqhLqOUj0fuwvZQchWe20kgz2PRS7x
	 47+AUAs50cs1vOEE5moQ7V2Bde9Xbtdzk5TEDrpLdwHwXojFdMqU+hFUKdmJxpfPM3fAG
	 qw+WyEAov4ZAfKi4pInZ76xJeXx9PDoxd7CgElenR8QT9MxY8cHaO+7Hw19hEuPA0nfbG
	 XSs2NlLAwZ6/HSyFfHrqFGHhi3BO0i0wj+MFLgsqZEhERaSErUi9lkhRqSezy+XL3KZpe
	 QMJ+fd+hzi3pb+bKuDDv5jqG6SkcapYNCTY4UzX0t0gqUZFeb1oXe0+PVjXOVrWGvWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793498242;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ldhDDTtZAE/3brSKAhksuwsG1IPpe3NESKnYVMmoFBE=;
	b=5Cz8AlVgUjQYXGha7uufsHUFBHlzALe1lzSkGnhyb6+5kQS/Du4ITql1TUwoqUMHnxje
	 RllVUx4tO7LLAdQvvLnMwzjHAVu4Zfil8dXMkh2EwOrpjbJkXl2KuJoANxZdKNTA8IfOo
	 N/YQ6PE8FBTEEPLuZVYDdWwDsuBfVM8hTXRdkTP7Z6SbbOV/TH225RB6Hu9Px9e34ZujJ
	 9nxUMuRp/VJ3jZyeMdQ7sYP02z3R/y8MjRvfnvraN0XzpgpojQCfGVIwuKC+FWzvLCwGR
	 ymkPprWG1iyCGavq87vebVgcLoPcwnJhL2NwTjhsLW1M/uzKdu3S9htXFGej8Dz0kEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uAYmsTxn;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C59606A329
	for <linux-api@vger.kernel.org>; Sun,  1 Nov 2026 01:57:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41C59606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uAYmsTxn
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a2d6cf958bso8544515e9.1
        for <linux-api@vger.kernel.org>; Sat, 31 Oct 2026 18:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793498240; x=1794103040; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ldhDDTtZAE/3brSKAhksuwsG1IPpe3NESKnYVMmoFBE=;
        b=uAYmsTxnVYOAxhIuO6akQJRAlwulHZ1cjkwNFSKIuLwxuMITROqm04zH8bg2jtdAiN
         K/q2Xv7O6neta4eG6DSc9d85IPEWiv1++igy29ZUlsr8AKb4Pw8hHevGM6CKovQDGs8p
         8kNi9wTr+vjarzKpUQpHytF8G944CMgJbukUoNCEdSh+49YhYerb/mSJYVUgYy+HarE1
         oUBMUty+81j//ZUZmDfTLrKQD5lVb23rSanXMXMqWrKZpIDmf1IeYUqKsCaVdZrygZnK
         9I/I/b6mqytwi3p1nsWGT6rMtbXnjrwlZ26NoWVYuNgErdJHIx9pErffmAQNAUQcGLmG
         s8dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793498240; x=1794103040;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ldhDDTtZAE/3brSKAhksuwsG1IPpe3NESKnYVMmoFBE=;
        b=GPa3rbn+2BI5scGbdgLk8EDBHkv1BN7B9KLdRpqPPn8O9q1xiQ7sVu3anmMmHwrD/G
         onMAkDyVM10gAPNGhlaYmV1ZXgrE8nD+o/b7e00VsKf9R5ayFY0z9nIhme5VNX25XZ/q
         uZWtslpMNpGd/g+HqwQR5NnZCU79+SYQJfjSZ8hdRWQ8GfF125v0aMd67lYcIv47w/hS
         ctMq66js48BJiOFO+OoM0TlFeyfgk6IOFSOSpj839rOzv8ci2mZMU54M2GFFkh6VHQAw
         3fB5YtW7seicyacKdzZQVbhHSvonyxELN1RgZ1ij3/le3UCfwulnhI5Km5VhPVNWJ9Z5
         SGxQ==
X-Forwarded-Encrypted: i=1; AKwUvBysNFHK8RREcuwGh3eU3/xB4xJ6+T/aULW9rrRpI5N1SSXiG93qill2TJ9T85mJCQ4Xr4a1AYBMtB0=@vger.kernel.org
X-Gm-Message-State: AFq9FYLqYfaMVyhQiRCgoOtxAC2FrxcirFmERHNbnaXFdxaIwGUdl19I
	8bJS5lUvoC6WzIVOilIotQ4/O4EuW1WLnolzRV9fGUkQLSyuBornkKDe
X-Gm-Gg: AYBFou2aCQ9NfY3uxyO6rG9+/FLCJ3SGJGsFV/ZKftf10Ic/NIWADOWp5DUVgTBYD2f
	7fqhj/+WPBvnJb9MujTYPxOUy88eUHm7zUUhgzpOBpT76NBRaQI41JmTBnVqV3URQdg9j9i/5AJ
	YrxUmhcT5QJ2+0B1jrId4zluoVhHDStZysw2OHDMmCjTvWD+H+cNdeMZA2A71V8X+yvXSoAQ1N5
	tiuupHzonTjehLgiaIHMNWoakdnSpnjYGcOv3IbYTJrHaxT5U6a9IjvdznVUEst4xDMdKO+EIYv
	iUhx1+gZ5gOkTLLQssP/kNmgweilJoVA7GthVaVMeek80SmzvQY6I6BzZi1n0wMl81h4436Cx2j
	sTPiDnW/n1h+TjzFDmkcvxZG8EXKzi/PNtoA82ZI/1lczbDXFml9s1l8ebCeHksKgvDYiG/lIHm
	82GPIfMPVk7IBVocDqYc7+B7msFSKJ1uc0T2Vkoo35N8FyndlYnzvcsCKh6bWmeFJojPQChJyz9
	zhXDl0n9GQL0UyWkD0evADfykIzK5nv5xEoT6Zivf6i5PDCrr58L3D6o+uawFok9CpzqS3XascF
	B4TJU0cqA50PvR0GaYwKLEJr
X-Received: by 2002:a05:600d:c:b0:4af:83ad:8f70 with SMTP id 5b1f17b1804b1-4af83ad8fa7mr31193005e9.35.1793498240391;
        Sat, 31 Oct 2026 18:57:20 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa81b7fe80sm273532835e9.11.2026.10.31.18.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 18:57:19 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Chris Mason <mason@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Chuck Lever <cel@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Sean Smith <defendthedisabled@gmail.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Amir Goldstein <amir73il@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	exfat@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-api@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [RFC PATCH v3 0/5] add provenance time (ptime)
Date: Sun,  1 Nov 2026 02:55:46 +0100
Message-ID: <20261101015551.786044-1-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an initial implementation of a new timestamp to indicate the
time when a file/directory was initially created.

This patch series takes inspiration from the one by Sean Smith
<defendthedisabled@gmail.com> [1], but using
file_setattr()/file_getattr() as suggested by Darrick J. Wong
<djwong@kernel.org> in [2].

The semantics of this new timestamp should be at least these:
- it should be the same as btime on a newly created file
- it's user-settable, so it can be preserved for backups, filesystem
  conversions, archives and any similar operation
- it should be preserved every time mtime gets preserved

and the correspondence with the other timestamps is as follows:

ctime <-> btime
mtime <-> ptime

Examples:
1) a .zsh_history file created in 2019, then after a few years the user
   decides to switch to another filesystem, copying the .zsh_history to
   the new home, in that case btime would have the timestamp of the copy
   and ptime would have the 2019 timestamp (just like mtime would have
   been preserved)
2) a symlink created in 2020 from the home directory to a /path going
   through the same process as the .zsh_history, in this case it would
   also make sense to sync the ptime to the 2020 timestamp instead of
   keeping only the btime (so the inode creation time).

The proof-of-concept code (for testing) for stat(1) and cp(1) is
available at https://github.com/koraynilay/coreutils (master branch)
(Note: these coreutils code changes are a prototype and won't be
submitted upstream as-is, but they work as expected in simple stat and
cp -a/--preserve=ptime tests)

Lastly, the name "provenance" and "ptime" are not final, I personally
don't have a strong opinion on any name, but while testing with stat(1)
I noticed that "Provenance" is definitely too long for the normal
output, so another option which would fit well is "Origin time",
abbreviated as "ntime" (OrigiN time) and not as "otime", as that would
conflict with btrfs' internal naming and create confusion.

v2 changes:
- fix permission bypass leading to ptime update on immutable and
  append-only files (found by sashiko[3])
- normalize ptime timestamp as done in fs/attr.c:notify_change() (found
  by sashiko[3])
- fix wording in vfs patch to be like the cover-letter

v3 changes:
- vfs: reject setting ptime with -EOPNOTSUPP on filesystems that do not
  support it instead of silently ignoring it (found by sashiko[4])
- vfs: fix not being able to clear immutable and append-only on files
  with ptime, and allow updating immutable/append-only atomically along
  with ptime (found by sashiko[4])
- btrfs: validate on-disk ptime nanoseconds and reset to otime if
  invalid (found by sashiko[4])
- btrfs: avoid re-assigning ptime on unrelated chattr calls (found by
  sashiko[4])
- add ntfs3 and exfat support as suggested by Amir Goldstein[5], but no
  vfat, smb, or nfs4 yet as they are a bit more complex
- move the introduction of fileattr_has_fsx_mask() from the btrfs patch
  to a standalone patch in the series
- btrfs: add fileattr_[gs]et to symlink and special file operations

Thanks.

[1]: https://lore.kernel.org/20260405195007.1306-2-DefendTheDisabled@gmail.com
[2]: https://lore.kernel.org/20260407014129.GC6192@frogsfrogsfrogs
[3]: https://sashiko.dev/#/patchset/20261027220532.736352-1-koray.fra%40gmail.com
[4]: https://sashiko.dev/#/patchset/20261028134728.294127-1-koray.fra%40gmail.com
[5]: https://lore.kernel.org/linux-btrfs/CAOQ4uxiuy0VwZj+3M-zRqQ49WTpHZpiaQ+6MZ8z8WdLjyQM_zA@mail.gmail.com/

koraynilay (5):
  vfs: add provenance time (ptime)
  vfs: add fileattr_has_fsx_mask()
  ntfs3: make crtime user-settable using ptime
  exfat: make crtime user-settable using ptime
  btrfs: add provenance time (ptime)

 fs/btrfs/btrfs_inode.h          |  4 ++++
 fs/btrfs/delayed-inode.c        |  6 ++++++
 fs/btrfs/inode.c                | 29 +++++++++++++++++++++++++-
 fs/btrfs/ioctl.c                | 12 ++++++++++-
 fs/btrfs/print-tree.c           |  1 +
 fs/btrfs/tree-log.c             |  3 +++
 fs/exfat/exfat_fs.h             |  2 ++
 fs/exfat/file.c                 | 36 ++++++++++++++++++++++++++++++++-
 fs/exfat/namei.c                |  1 +
 fs/file_attr.c                  | 33 ++++++++++++++++++++++++++++--
 fs/ntfs3/file.c                 | 14 +++++++++++--
 fs/ntfs3/frecord.c              |  8 +++++++-
 fs/stat.c                       |  2 ++
 include/linux/fileattr.h        | 26 +++++++++++++++++++++---
 include/linux/stat.h            |  1 +
 include/uapi/linux/btrfs_tree.h |  3 ++-
 include/uapi/linux/fs.h         |  8 +++++++-
 include/uapi/linux/stat.h       |  7 ++++++-
 18 files changed, 182 insertions(+), 14 deletions(-)


base-commit: cbbddb6b08cc9900a87cccaa9b22bbe06aa4f50a
-- 
2.56.0

