From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 0/3] signalfd: a kernel interface for dumping/restoring
	pending signals (v3)
Date: Wed, 16 Jan 2013 17:00:37 +0100
Message-ID: <20130116160037.GA1167@redhat.com>
References: <1358182435-19245-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1358182435-19245-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>, Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On 01/14, Andrey Vagin wrote:
>
> v3: minor cleanups

I have no more comments ;)

Obviously I can't ack this series, especially the API.

But correctness-wise everything looks fine to me, so

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
