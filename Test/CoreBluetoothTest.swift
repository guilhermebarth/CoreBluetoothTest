import SwiftUI
import CoreBluetooth


class CoreBluetoothTest: NSObject, ObservableObject {
    
    private var centralManager: CBCentralManager?
    private var peripherals: [CBPeripheral] = []
    @Published var peripheralsNames: [String] = []
    private var devideCount: Int = 0
    @ObservedObject private var beaconDetector = BeaconDetector()
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
}

extension CoreBluetoothTest: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.centralManager?.scanForPeripherals(withServices: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData data: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            
            devideCount += 1
            
            self.peripherals.append(peripheral)
            print("Device número \(devideCount): \(peripheral.identifier), RSSI: \(RSSI)")
            
            //let nearbyInteraction = NearbyInteractionTest()
            //nearbyInteraction.startupMPC(identifier: peripheral.identifier.uuidString)
            
            calculateRssi(rssi: Double(RSSI))
            
            central.connect(peripheral)
            print("Efetuando conexão \(peripheral.state)")
            
            // 3 = Desconectando, 2 = Conectado, 1 = conectando, 0 = Desconectado
            if peripheral.name == nil {
                self.peripheralsNames.append("\(peripheral.identifier.description) RSSI: \(RSSI)")
            } else {
                self.peripheralsNames.append(peripheral.name ?? "Dispositivo sem nome")
            }
        }
    }
    
    func calculateRssi(rssi: Double)
    {
        var txPower = -59.0 //hard coded power value. Usually ranges between -59 to -65

        var ratio = rssi * 1.0 / txPower
        if (ratio < 1.0) {
            print("Distância do Beacon: \(pow(ratio,10))")
        }
        else {
            var distance =  (0.89976) * pow(ratio,7.7095) + 0.111
            print("Distância do Beacon: \(distance)")
        }
        
        //pow(10, ((-56-Double(rssi))/(10*2)))*3.2808
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Perdido conexao com: \(peripheral.identifier), Status: \(peripheral.state)")
        // 3 = Desconectando
        print("Error: \(error)")
        central.connect(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        print("Conexão realizada com sucesso com: \(peripheral.identifier)")
        //calculateRssi(rssi: Double(peripheral.readRSSI() ?? 0))
        //beaconDetector.startScanning(myID: peripheral.identifier)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Ocorreu um erro:")
        print(error as Any)
    }
}
