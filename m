From: Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: Support for BQ28Z610 Battery Monitor IC
Date: Tue, 5 Sep 2017 09:03:26 +0200
Message-ID: <877fa5e7-2f4b-08a0-6d31-b128d56d119a@enneenne.com>
References: <BA23DB07EF784484A47D0FA46BA628BA.MAI@stesalit-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BA23DB07EF784484A47D0FA46BA628BA.MAI@stesalit-inc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: rajender.reddy@stesalit.in
Cc: afd@ti.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, security@kernel.org, linux-api@vger.kernel.org, trivial@kernel.org
List-Id: linux-api@vger.kernel.org

On 04/09/2017 15:53, rajender.reddy@stesalit.in wrote:
> Dear Rodolfo Giometti,
> 
> As discussed please find attached patch.
> Please let me know if you need more details.

It looks OK to me... however:

- rewrite the patch's title as "power bq27xxx_battery: add support for BQ28Z610 
battery monitor IC"

- align the "=" characters as follow:

+	[BQ28Z610] = {
+		[BQ27XXX_REG_CTRL]     = 0x00,
+		[BQ27XXX_REG_TEMP]     = 0x06,
+		[BQ27XXX_REG_INT_TEMP] = INVALID_REG_ADDR,
+		[BQ27XXX_REG_VOLT]     = 0x08,
...

Then send the patch to the mail list or maintainers ad described into the 
MAINTAINERS file and adding me in Cc.

Good job! :-)

Ciao,

Rodolfo

-- 

HCE Engineering                      e-mail: giometti@hce-engineering.it
GNU/Linux Solutions                          giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Cosino Project - the quick prototyping embedded system - www.cosino.it
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
