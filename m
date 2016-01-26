From: Kevin Hilman <khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFD] How to support KBUILD_OUTPUT for kselftest?
Date: Tue, 26 Jan 2016 11:47:40 -0800
Message-ID: <7hk2mwnmw3.fsf@baylibre.com>
References: <56849D4B.6010008@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56849D4B.6010008-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> (Bamvor Jian Zhang's message of
	"Thu, 31 Dec 2015 11:13:15 +0800")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Tyler Baker <tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:

> I am trying to improve cross compiling support for kselftest recently. Right
> now I am stuck when I want to enable KBUILD_OUTPUT(O=xxx). It exist in wiki of
> kselftest[1]. Hope it is not a duplicated work.

Just want to echo the need for this feature because trying to build
kselftests for a kernel built with KBUILD_OUTPUT is broken due to
hard-coded assumptions about paths to headers, etc.

I haven't dug any deeper into how to fix it though...

Kevin
