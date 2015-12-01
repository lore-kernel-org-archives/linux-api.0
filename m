From: David Decotigny <ddecotig@gmail.com>
Subject: Re: [PATCH net-next v3 03/17] net: ethtool: add new
 ETHTOOL_GSETTINGS/SSETTINGS API
Date: Mon, 30 Nov 2015 16:47:51 -0800
Message-ID: <CAG88wWa43THeBVyUyS6DirjQM-q1MxGgnZxAGZnU-pKNh1_NsQ@mail.gmail.com>
References: <1448921155-24764-4-git-send-email-ddecotig@gmail.com> <201512010847.SVw9zucX%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <201512010847.SVw9zucX%fengguang.wu@intel.com>
Sender: netdev-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, "David S. Miller" <davem@davemloft.net>, Ben Hutchings <ben@decadent.org.uk>, Amir Vadai <amirv@mellanox.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, linux-mips@linux-mips.org, fcoe-devel@open-fcoe.org, Eric Dumazet <edumazet@google.com>, Eugenia Emantayev <eugenia@mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Ido Shamay <idos@mellanox.com>, Joe Perches <joe@perches.com>, Saeed Mahameed <saeedm@mellanox.com>, Govindarajulu Varadarajan <_govind@gmx.com>, Venkata Duvvuru <VenkatKumar.Duvvuru@emulex.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Eyal Perry <eyalpe@mellanox.com>, Pravin B Shelar <pshelar@nicira.com>, Ed Swierk <eswierk@skyportsystems.com>, Robert Love <robert.w.love@intel.com>, James E.J. Bott
List-Id: linux-api@vger.kernel.org

On Mon, Nov 30, 2015 at 4:04 PM, kbuild test robot <lkp@intel.com> wrote:
>>> include/linux/ethtool.h:129:3: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]

prepared a fix for that, will be part of next patch update after feedback.
