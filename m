From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 15/24] proc: give task_struct instead of pid into
	first_tid
Date: Tue, 14 Jul 2015 20:11:25 +0200
Message-ID: <20150714181125.GD8088@redhat.com>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org> <1436172445-6979-16-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436172445-6979-16-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Roger Luethi <rl@hellgate.ch>, Arnd Bergmann <arnd@arndb.de>, Arnaldo Carvalho de Melo <acme@kernel.org>, David Ahern <dsahern@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Pavel Odintsov <pavel.odintsov@gmail.com>
List-Id: linux-api@vger.kernel.org

On 07/06, Andrey Vagin wrote:
>
> It will be more convenient when this function will be used in
> task_diag.

Again, I won't argue, but perhaps the changelog(s) could say a bit
more about this change (see my reply to 8/24).

Oleg.
