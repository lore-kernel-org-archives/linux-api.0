From: Andreas Schwab <schwab@suse.de>
Subject: Re: [PATCH v9 00/24] ILP32 for ARM64
Date: Wed, 25 Jul 2018 11:48:29 +0200
Message-ID: <mvm4lgnzlw2.fsf@suse.de>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
        <20180724173957.GA22106@yury-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180724173957.GA22106@yury-thinkpad> (Yury Norov's message of
        "Tue, 24 Jul 2018 20:39:57 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, "David S . Miller" <davem@davemloft.net>, Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <james.hogan@imgtec.com>James
List-Id: linux-api@vger.kernel.org

On Jul 24 2018, Yury Norov <ynorov@caviumnetworks.com> wrote:

> This is the update of the series based on 4.17 kernel
> https://github.com/norov/linux/tree/ilp32-4.17

Note that commit 947bd8e7cd (arm64: ilp32: add
is_ilp32_compat_{task,thread} and TIF_32BIT_AARCH64) conflicts with
commit 9dd9614f54 (arm64: ssbd: Introduce thread flag to control
userspace mitigation) (which has been backported to stable).

Andreas.

-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."
