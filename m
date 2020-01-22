From: Jan Ziak <0xe2.0x9a.0x9b-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v1] pin_on_cpu: Introduce thread CPU pinning system call
Date: Wed, 22 Jan 2020 16:48:06 +0100
Message-ID: <CAODFU0pi6MVJ+XgUmZRS_+ihAyZF+aq_V7sdnbeNeDtPzCZS=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello

I would like to note that this does not help userspace to express
dynamic scheduling relationships among processes/threads such as "do
not run processes A and B on the same core" or "run processes A and B
on cores sharing the same L2 cache".

Sincerely
Jan
