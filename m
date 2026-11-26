Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795679635;
	b=H4ngLUq8awycBJ3jahZJCen+tqZ7adnBPyZIfUsCmrT9B7h2RGCy6KIbuiG/CAfK/ETy
	 hNuxExDhlgf3I93guVp2Gn1BZ9r+FBROy3c4PCvTd7de4M/6+8QyciKmGJa4opdEIjxFq
	 n3FVrTYq61rIf4a+w9z5zJeRA6OWk/GTSfe7KKl3bpMhGJOwH2WBT13OQeGC/d+WMgMnY
	 nBHfoQWnKQH3mI7V2J4DOz2q3zLf4H+0aC5o2DOvK5oIffM7Rh2GV97lJz8+4nmyrhIJ/
	 4CSLIk6kHBHE3Wq/46cEtP/TaFNsQqRvbjPn0AMyxwHS0HJHoeT3uJa1JwFH08hu7QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795679635;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=6mcRydve0LMwyiwH6iWTrTwCOq45Fwyg68Imy88m+Lk=;
	b=ZTvZWuht3g1n5kAU33zSlsZLRZ4SZ3fx61KtWXNCru3TJH5fetnf9ahofnTdGq/08USl
	 MpQ2OTBBRP26Gtg26PYGRoad7akzY7lTqb5FnjsCN0lxwa9aHi6FMLJvAyWoMu2TPHirO
	 aArZVTRwAWbnjlOXQl0bxxErgUOj5If6b3WVcxRy+Z2QnC1bcGeeJlaIP3Y0KEEaAFyBH
	 3H126J8Z+0rQvsKBZucemLQ+iEmiX/vUsA8NEsjO5pXEKqEvpZcZSICJNhH7pA0FqNgWk
	 2F9G1tRqt2yHsE/MHyM3CztRtfFjlQyzhPihIbRWHaHSw7rTZSyFceXlVVFstKTlqUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=mMUjyya9;
	arc=none smtp.remote-ip=117.135.210.5
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DC9606A31E;
	Thu, 26 Nov 2026 07:53:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75DC9606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=mMUjyya9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=6m
	cRydve0LMwyiwH6iWTrTwCOq45Fwyg68Imy88m+Lk=; b=mMUjyya9D9TbTiE2SH
	RfJUZiCmGaP4pqmaYYGR3awJ2zCbrCa/kKdMYWPsg0vewQwVJe8vInIJYB6bbgWU
	Geg0NWx2Lvt2WDe1onfb561znv1XO8+K6qtTbcsEkBHXopw7WpIbtHgkaaPfk0B6
	5eVPOa7ifYm8zEvigvF8584zU=
Received: from ubuntu (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3V55R5QdrnDkPKg--.34500S2;
	Thu, 26 Nov 2026 15:53:00 +0800 (CST)
From: Shaopei Zhu <shaopei_1012@163.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	exfat@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v7] exfat: add EXFAT_IOC_COMBINE to append a file's clusters to another
Date: Thu, 26 Nov 2026 15:52:47 +0800
Message-ID: <20261126075247.850895-1-shaopei_1012@163.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAKYAXd_ap120uprmarov-GuO0fb1eXEgw-U8G08L1xRJ9bv18A@mail.gmail.com>
References: <20261124230746.850528-1-shaopei_1012@163.com> <CAKYAXd_ap120uprmarov-GuO0fb1eXEgw-U8G08L1xRJ9bv18A@mail.gmail.com>
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
X-CM-TRANSID:_____wD3V55R5QdrnDkPKg--.34500S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAryrAryfGr15Jw1xCFWUCFg_yoW5ZFWkpF
	WFqrn8tw1kGr1Ikwn7Z3W7WryS9rZ3JF13Xr9IgryDZ390gFy0yFyxKw1UZ3y5Grsaqay0
	qa1rury5GrZ8ZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UrnY7UUUUU=
X-CM-SenderInfo: pvkd01phlbiiirs6il2tof0z/xtbC6Rwtu2sH5VxjMQAA3k

On Wed, Nov 25, 2026 at 11:18 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
> Is there a specific device or product expected to use this feature, or
> is it being added as a potentially useful capability without a
> concrete use case? If there is a target device or workflow, could you
> share some details?

Hi Namjae,

Thanks for the review.  Yes, it is going to be used in camera products
that record to exFAT SD cards.  The open source user is exfatcombine,
posted for exfatprogs [1], and a test for fstests (exfat/002) is posted
as well.

The workflow: cameras and dashcams keep motion or position data with
the video, e.g. gyroscope and accelerometer samples for stabilization,
or GPS.

The products on the market keep that data in one of three ways:

- as a timed metadata track inside the MP4, e.g. GoPro's GPMF, muxed
  while recording, so that the samples are interleaved with the video
  in the mdat box and indexed in the moov box;
- as a separate sidecar file next to the video, e.g. the GPS logs of
  dashcams;
- as a trailer appended after the MP4 boxes when recording stops,
  which players ignore and stabilization tools read.

A sidecar file is lost in practice: users copy, share or import only
the video file, and matching the two by name breaks once either is
renamed or moved.  A track needs the muxer to take the samples in real
time along with the video.  Where the sensor data comes from another
writer, at a few hundred samples per second, it cannot go into the file
the muxer is writing, so it is written to a separate file in the same
directory during recording and appended as a trailer when recording
stops.

That last step is what this ioctl is for.  Today the sensor file is
copied into the video file, up to tens of MiB per recording, while the
user waits for the camera to be ready again, with flash wear and free
space needed for the copy.  With this ioctl its clusters are appended
to the video file instead, and the sensor file is removed.

> I suggest changing EXFAT_IOC_COMBINE to transfer only the source's
> cluster chain to the destination, leaving the source linked as an
> empty file. Userspace can unlink it afterward if desired.

The sensor file is only a temporary part of the recording.  With the
unlink in the same call, a power loss, e.g. the battery being pulled
right after recording stops, leaves one of the two states the
recording application already handles: not combined yet, or combined.
With the unlink in user space there is a third one, the combined video
next to an empty sensor file, which looks like the first one unless
every application also checks the size of the file.  It would be easy
to append the sensor data a second time, or to leave an empty file on
a card that users read directly.

Doing it in the same call also refuses the whole call before anything
is changed if the source may not be removed, instead of leaving an
emptied file that cannot be deleted, and it removes the file that was
passed in, not whatever its name refers to by the time user space gets
to unlink it.  The unlink goes through start_removing_dentry(),
security_path_unlink() and vfs_unlink(), so it gets the same checks as
unlink(2).

Does this address your concern?

Thanks,
Shaopei

[1] https://github.com/exfatprogs/exfatprogs/pull/412

