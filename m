From: Tobias Klauser <tklauser@distanz.ch>
Subject: Re: [patch v6 3/3] Doccumentation: jtag: Add bindings for Aspeed SoC
 24xx and 25xx families JTAG master driver
Date: Mon, 28 Aug 2017 10:36:11 +0200
Message-ID: <20170828083610.GB1951@distanz.ch>
References: <1503418256-5215-1-git-send-email-oleksandrs@mellanox.com>
 <1503418256-5215-4-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1503418256-5215-4-git-send-email-oleksandrs@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Shamray <oleksandrs@mellanox.com>
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, openbmc@lists.ozlabs.org, joel@jms.id.au, jiri@resnulli.us, linux-serial@vger.kernel.org, mec@shout.net, vadimp@maellanox.com, system-sw-low-level@mellanox.com, robh+dt@kernel.org, openocd-devel-owner@lists.sourceforge.net, linux-api@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>
List-Id: linux-api@vger.kernel.org

On 2017-08-22 at 18:10:56 +0200, Oleksandr Shamray <oleksandrs@mellanox.com> wrote:
> It has been tested on Mellanox system with BMC equipped with
> Aspeed 2520 SoC for programming CPLD devices.
> 
> Signed-off-by: Oleksandr Shamray <oleksandrs@mellanox.com>
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> Acked-by: Rob Herring <robh@kernel.org>
> ---
> v5->v6
> Comments pointed by Tobias Klauser <tklauser@distanz.ch>
> - Small nit: s/doccumentation/Documentation/

There's still one 'c' too many in 'Doccumentation' in the subject (in
case you're doing another respin of the series).
