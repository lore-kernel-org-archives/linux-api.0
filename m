From: Stuart Longland <stuartl@longlandclan.id.au>
Subject: Re: [patch v6 0/3] JTAG driver introduction
Date: Fri, 25 Aug 2017 18:50:23 +1000
Message-ID: <593cd0d3-8e06-0992-c155-1322014c0477@longlandclan.id.au>
References: <1503418256-5215-1-git-send-email-oleksandrs@mellanox.com>
 <CACRpkdZePXyo8Q36mBH7OnJU3E=yWPWSGkGUOH=zJFMjM=Yrhw@mail.gmail.com>
 <CAPLgG==Jj=Ys=SvhOCspSfunbWnuqPySvW9RfuqE8HYnG4C=ZQ@mail.gmail.com>
 <CACRpkdbozWaL0RXyZXjzxYK3JHiqYziSkTGSgGORdptX-rwR8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5873573788368996152=="
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CACRpkdbozWaL0RXyZXjzxYK3JHiqYziSkTGSgGORdptX-rwR8A@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Linus Walleij <linus.walleij@linaro.org>, Rick Altherr <raltherr@google.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>, Arnd Bergmann <arnd@arndb.de>, system-sw-low-level@mellanox.com, Greg KH <gregkh@linuxfoundation.org>, OpenBMC Maillist <openbmc@lists.ozlabs.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, openocd-devel-owner@lists.sourceforge.net, mec@shout.net, Rob Herring <robh+dt@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Tobias Klauser <tklauser@distanz.ch>, Oleksandr Shamray <oleksandrs@mellanox.com>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============5873573788368996152==
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="14jdK5JVTNEEBgGWobCjMLbpSGuOqeIbc"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--14jdK5JVTNEEBgGWobCjMLbpSGuOqeIbc
Content-Type: multipart/mixed; boundary="G4ojsckFeEJJiAK0j3vAe59BPUDr6Q1GF"
From: Stuart Longland <stuartl@longlandclan.id.au>
To: Linus Walleij <linus.walleij@linaro.org>,
 Rick Altherr <raltherr@google.com>
Cc: Oleksandr Shamray <oleksandrs@mellanox.com>,
 "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
 Arnd Bergmann <arnd@arndb.de>, system-sw-low-level@mellanox.com,
 Greg KH <gregkh@linuxfoundation.org>,
 OpenBMC Maillist <openbmc@lists.ozlabs.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 openocd-devel-owner@lists.sourceforge.net, mec@shout.net,
 Rob Herring <robh+dt@kernel.org>,
 "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
 Tobias Klauser <tklauser@distanz.ch>,
 "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Message-ID: <593cd0d3-8e06-0992-c155-1322014c0477@longlandclan.id.au>
Subject: Re: [patch v6 0/3] JTAG driver introduction
References: <1503418256-5215-1-git-send-email-oleksandrs@mellanox.com>
 <CACRpkdZePXyo8Q36mBH7OnJU3E=yWPWSGkGUOH=zJFMjM=Yrhw@mail.gmail.com>
 <CAPLgG==Jj=Ys=SvhOCspSfunbWnuqPySvW9RfuqE8HYnG4C=ZQ@mail.gmail.com>
 <CACRpkdbozWaL0RXyZXjzxYK3JHiqYziSkTGSgGORdptX-rwR8A@mail.gmail.com>
In-Reply-To: <CACRpkdbozWaL0RXyZXjzxYK3JHiqYziSkTGSgGORdptX-rwR8A@mail.gmail.com>

--G4ojsckFeEJJiAK0j3vAe59BPUDr6Q1GF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

[Note: dropping vadimp@maellanox.com as SMTP server complained about the
DNS server returning NXDOMAIN.  Apologies.]
On 25/08/17 18:32, Linus Walleij wrote:
> Gnah!
> Whoever writes a slot-in replacement making the character device
> take precendence wins lots of karma.

What would such a replacement look like though?

Some sort of system whereby you can read/write single-line commands as
if talking to a GPIO expander over a UART?

Would you access the GPIOs one by one, or would you perhaps map them
into a bitmap (maybe arbitrarily, up to 64-bits wide) and perform masked
operations on the bitmap?

I'm no fan of the sysfs GPIO interface, but it beats poking around at
registers behind the kernel's back.
--=20
Stuart Longland (aka Redhatter, VK4MSL)

I haven't lost my mind...
  ...it's backed up on a tape somewhere.


--G4ojsckFeEJJiAK0j3vAe59BPUDr6Q1GF--

--14jdK5JVTNEEBgGWobCjMLbpSGuOqeIbc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJZn+TPAAoJEPlUu7t5SNVG67kP/j8MgSUNySU8dWR/Xm22ACvo
kRwGWNLrKlMnWiPxGhZlRTTSrewT6jeuCQLueY2CPMmH0omtLJCNm6ZiG5B/xa9d
8lJ/+D9MmrPAsqdArCRXyiakZlNU20IvyFl8loN+DgRnVzpx1UOjVWGkcwnhei1D
/Qo3XF/wcR5gLHkCsC9j7NCN+hsOwwRPlM+NO9lQvYuRb/pAQ9JlWczrR5kC2NK+
Ln3Aqqesbv4tQ28S3pfR+AoQi/qKM2IHJXl4K4kM1C4wW6aajls2jZZ/8r6xWC9u
DIVXv6R7WpSUPxeHNlmn9TzJPTCFd1CV7tMkP9ACiS++rZurXQsS/Bu5EwKvbkrV
xnox6io+SQD0mn/nXpi7N/6NPUugeLIv47fsi2NKXs+nm97soL+6dliFOLDsR5G9
4JKRUQkhrq0o+0qWWnRdALrEj0FgGbaF5oJDWkDeEp89UIzbzPcVHXQElCcznDXZ
YNBwa+5V9XhXiPkilOgI/qQ0iAJaG9bM2HpALQaCrHRbvsD6/0IWHxjw4KRx2S7j
k43T1LkrvtIfQb1fFpZVPD19Noybgl7y1CMmi+5bZOHzUwaeUYe/pF4DETBhy6yh
sgvc9J/I/ChtfYm8TQeX7+RdrAdhebMrvP6uWDpbNrYEIyScpg9xgn9DcCSCi+sO
a8kIjjqlfdI797Zeclxm
=GgQT
-----END PGP SIGNATURE-----

--14jdK5JVTNEEBgGWobCjMLbpSGuOqeIbc--


--===============5873573788368996152==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

--===============5873573788368996152==--
