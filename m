Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297C45FDA7;
	Sat, 10 Oct 2026 23:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791676212; cv=none; b=EarANt/I/otoXbnQ9whZ+EY4nCn7rwZiuNYF06E7TL2M8E+9OANPhzUcD2s+UAqIHdN5HoQ1S73NMtqxTV6UbyewFR7kLGNz+fqQWaTzHTpv4kQfZC1sHyKu51kR0Gqhw1AUZrwfUv0zpcGuKi6lw34lbbfAyBKimIao3f+PYb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791676212; c=relaxed/simple;
	bh=9FL9cUDrGCp+qMK51gHAgC2YfEkxaRRY5xGgvKcAOg8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gX8JxTQqvwTyThFaQaHaWxi8oqWBiKY6oZRuN00ss7cQWg0DBa6ii7kahb3ryUL8lpTDXtYqSMcV1CmSPXH5NAcKD60ZiM/IaKWr6xoiYv35DibuiudkAuGWo3NNxMhW1nwBJFH23x30m4SlRdX4QLg8Kk/TskyZzJzAx+DiVrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; dkim=pass (1024-bit key) header.d=goodmis.org header.i=@goodmis.org header.b=fl3Kqq1Y; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=goodmis.org header.i=@goodmis.org header.b="fl3Kqq1Y"
Received: from omf18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 28FEC405D0;
	Sat, 10 Oct 2026 23:50:01 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf18.hostedemail.com (Postfix) with ESMTPA id 72D0E2E;
	Sat, 10 Oct 2026 23:49:57 +0000 (UTC)
Date: Sat, 10 Oct 2026 19:49:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: =?UTF-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, Shuah
 Khan <shuah@kernel.org>, willy@infradead.org,
 mathieu.desnoyers@efficios.com, David Laight
 <david.laight.linux@gmail.com>, Linus Torvalds
 <torvalds@linux-foundation.org>, akpm@linux-foundation.org, Yafang Shao
 <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, arnaldo.melo@gmail.com,
 Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org,
 kernel-dev@igalia.com, linux-mm@kvack.org, linux-api@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/6] treewide: Replace memcpy(..., current->comm)
 with copy_task_comm()
Message-ID: <20261010194956.6933a224@226.227.38.69.naturalwireless.com>
In-Reply-To: <20260911-tonyk-long_name-v7-2-34e1ee1564ae@igalia.com>
References: <20260911-tonyk-long_name-v7-0-34e1ee1564ae@igalia.com>
	<20260911-tonyk-long_name-v7-2-34e1ee1564ae@igalia.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 72D0E2E
X-Stat-Signature: us5mpmssduqj1be3mbmjhfoyx6euk8qh
X-Rspamd-Server: rspamout01
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18aOPZdFzzPMcDV2LVtTbVyS5dgw9MYz/Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=9FL9cUDrGCp+qMK51gHAgC2YfEkxaRRY5xGgvKcAOg8=; b=fl3Kqq1YKaNwUAT2ewO8D37Si2di3QECApP5IKx/xRtmhETBuCicqagOGEnk+MxahX4DFkIqvyz8yqB67h0zwH4P22/9Vi1IuZcDU/dtRio5piddu4fOn5o03+m43fJKGd81NA1c5LhgtCasezWRD/U9fEFzq3MK/tDnWg/sTYo=
X-HE-Tag: 1791676197-585340
X-HE-Meta: U2FsdGVkX1+wsc8QC0fHf+UbyellR29lm+C/KUyXjDtET6zrwfqebiXgzyo/sWYepWg2KpG+BTsYJk02OhpsGn4BTl4DliD/wdCa9XSreOsKru+DcKWBaONbFqgieOYFdI2oT39c+PV9V41OCZ/dMEoU08PGbiPorkytl1K8CGxM1DYQsC254CddrjZqAEwbiZzlervoin6exIeoOFRpo/hjcurftnLW9pfWsTI40jjI5+b+rzPHeWovsyysHMHa5zPKRZQAUyf+0pFS3nBhrCccXGlj6WeqArb54058yQTNmxkTKPUBxJxgxh/w8GhJ0hMSiIy6Q56ViV1LF2wOONf7t92dbrtZu19QjOQL9/72CCQdRf+ZPmF8IWOTxbXB3vjho2ch9QBw/LxRUSzlQsRSMXqVg74rXjY7ue0LozwwmaBRBdUNkAsJSYFW/t8HUlXpzdV1m6S84TsuiicAPw==

On Fri, 11 Sep 2026 22:23:59 -0300
Andr=C3=A9 Almeida <andrealmeid@igalia.com> wrote:

> In order to increase the size of current->comm[] and to avoid breaking any
> existing code, replace memcpy() with copy_task_comm(). This new function
> makes sure that the copy is NUL terminated. This is crucial given that the
> source buffer might be larger than the destination buffer and could
> truncate the NUL character out of it.
>=20
> Signed-off-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
