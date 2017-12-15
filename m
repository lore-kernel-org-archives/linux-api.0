From: =?UTF-8?Q?Iago_L=c3=b3pez_Galeiras?= <iago@kinvolk.io>
Subject: Re: [PATCHv3, 1/2] capability: introduce sysctl for controlled
 user-ns capability whitelist
Date: Fri, 15 Dec 2017 12:10:00 +0100
Message-ID: <b4367cb6-82a0-5e5b-f94f-2581ba207f77@kinvolk.io>
References: <20171205223101.12765-1-mahesh@bandewar.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171205223101.12765-1-mahesh@bandewar.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mahesh Bandewar <mahesh@bandewar.net>, LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
Cc: Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Serge Hallyn <serge@hallyn.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>, Mahesh Bandewar <maheshb@google.com>
List-Id: linux-api@vger.kernel.org

On 12/05/2017 11:31 PM, Mahesh Bandewar wrote:
> +The value is expressed as two comma separated hex words (u32). This
> +sysctl is avaialble in init-ns and users with CAP_SYS_ADMIN in init-ns
> +are allowed to make changes.

Typo: avaialble -> available
